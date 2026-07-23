class MenderArtifact < Formula
  desc "CLI tool for managing Mender artifact files"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-artifact/archive/refs/tags/4.4.1.tar.gz"
  sha256 "c7002052028496f230c34ef6f0488bf5e8ca32b075b7a96555532fe928aed984"
  license "Apache-2.0"

  # exclude tags like `3.4.0b1` and `internal-v2020.02`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "95c53135249208f87ff8def2a9b313b72505677e932feef65c94903b6ae736b0"
    sha256 cellar: :any, arm64_sequoia: "5211e2db7a2de9defbd0f3593370cff1eb52a8b7bbcf1474f87540940925b103"
    sha256 cellar: :any, arm64_sonoma:  "23a62d443a68a8b97e087b331626ce425187623d7c326edb5e432fb413527326"
    sha256 cellar: :any, sonoma:        "fe09cc1128f493aa9d7d12a4e0e2337105f385b576a0e968239636bae0b825e3"
    sha256 cellar: :any, arm64_linux:   "f9e172d57686537a4b0e0af7184b384de95be61a2e76c8a427758fc83edff377"
    sha256 cellar: :any, x86_64_linux:  "aa529657edc6af5ec7991b9157156e07a10ae6ea5b1ba378b39999b9423c529f"
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
