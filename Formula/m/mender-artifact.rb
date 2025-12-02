class MenderArtifact < Formula
  desc "CLI tool for managing Mender artifact files"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-artifact/archive/refs/tags/4.2.0.tar.gz"
  sha256 "14ba008df9b24321de72821de394bc4326e4dd9e17ed7c111340689e90d8b596"
  license "Apache-2.0"

  # exclude tags like `3.4.0b1` and `internal-v2020.02`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f1ed0f0e51051da55cb919c1a4125a767a97f326d9a0898d1c7ed0cbd9ec303"
    sha256 cellar: :any,                 arm64_sequoia: "f1ff305b7019e60a2da814e997f604b9e8d2c852a324e486dfc370ca532e4f79"
    sha256 cellar: :any,                 arm64_sonoma:  "e2596b83eb8c1ff193d4df5e57ff1b3eeabba5a270885a8e2e5c86e2295966b7"
    sha256 cellar: :any,                 sonoma:        "90a3ba363fd15ef0a110c87f8434d017eb1c092774119570535ca02f119bedc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6883b8d3f4b8b6b571d5b8b1eb0df19594651b33af7777a2c63ad48521dd300d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bc04e3ccb4cd4838c1cbcf2f8e07906346c28fbb45d766f526ead3f66da51c0"
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
        Compatible devices: [beaglebone]
    EOS
  end
end
