class MenderArtifact < Formula
  desc "CLI tool for managing Mender artifact files"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-artifact/archive/refs/tags/4.3.0.tar.gz"
  sha256 "12cd9b6f8408df8697c4907c8ea639e50958a9e55816cc276e57d22d19227c46"
  license "Apache-2.0"

  # exclude tags like `3.4.0b1` and `internal-v2020.02`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3567bec3746023c8ed817443f890cfc10861ae5e458d975bc23911fe16435953"
    sha256 cellar: :any,                 arm64_sequoia: "9dc83efe348be8c6fcc0f0cd4a9c673f2f433a3a36c4bd13a4c4bb29a6d70dd3"
    sha256 cellar: :any,                 arm64_sonoma:  "eae5331deb3080625a42c7b401b678bb647ec9ad9158156357bdd0a59c4e983c"
    sha256 cellar: :any,                 sonoma:        "12ef6ce4e6ed7c6bf0d80ed67fa0b9333d7f0559b0cd1f14c37b45769c59800a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbcd872397e2ea799bb7f84692fb3ec49970fdac6c89af548d101c0eb49e21ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "323bfc97ecbe583bb71a076ec11e339f6c2c4d8fb519556be51ba2a5a606d85f"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "dosfstools" # fsck.vfat for vfat file systems in artifacts
  depends_on "e2fsprogs" # manipulation of ext4 file systems in artifacts
  depends_on "mtools" # manipulation of vfat file systems in artifacts
  depends_on "openssl@3"

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for github.com/mendersoftware/openssl)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X github.com/mendersoftware/mender-artifact/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    # mender-artifact doesn't support autocomplete generation so we have to
    # install the individual files instead of using
    # generate_completions_from_executable()
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_mender-artifact"
    bash_completion.install "autocomplete/bash_autocomplete" => "mender-artifact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mender-artifact --version")

    # Create a test artifact
    (testpath/"rootfs.ext4").write("")

    output = shell_output("#{bin}/mender-artifact write rootfs-image " \
                          "-t beaglebone -n release-1 -f rootfs.ext4 -o artifact.mender 2>&1")
    assert_match "Writing Artifact...", output
    assert_path_exists testpath/"artifact.mender"

    # Verify the artifact contents
    output = shell_output("#{bin}/mender-artifact read artifact.mender")
    assert_match <<~EOS, output
      Mender Artifact:
        Name: release-1
        Format: mender
        Version: 3
        Signature: no signature
        Compatible types: [beaglebone]
    EOS
  end
end
