class MenderArtifact < Formula
  desc "CLI tool for managing Mender artifact files"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-artifact/archive/refs/tags/4.4.2.tar.gz"
  sha256 "d8e9e18e48a2124e5e367ffafb3313a3dcba7a8a8a8b162b1dcb8791964c6385"
  license "Apache-2.0"

  # exclude tags like `3.4.0b1` and `internal-v2020.02`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b209b7c78717019270f7a2382ee493746c1dcaf40b3dbd48642aab94c7cdbd30"
    sha256 cellar: :any, arm64_tahoe:       "71f4de471c92087249e9c38eb2daee56696ecd2eb26e3f4f6373777a11933a6e"
    sha256 cellar: :any, arm64_sequoia:     "4db17100096cc70d59d000e50ec020dc2db58861b4df6a1b9026e4802be611f1"
    sha256 cellar: :any, arm64_sonoma:      "4839a66ed29d127d308c68c6ac2934c80e4c2de60556ff60639642540e702668"
    sha256 cellar: :any, arm64_linux:       "c7756ab0e7d4f92519682d292dbb91c18de61c2d83ca6e8fe1a6e5edf3c0359e"
    sha256 cellar: :any, x86_64_linux:      "0d991da6100285bade77edc383e40ee7fc3de273c9222c6fcdfcad1316afaaaf"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "dosfstools" # fsck.vfat for vfat file systems in artifacts
  depends_on "e2fsprogs" # manipulation of ext4 file systems in artifacts
  depends_on "mtools" # manipulation of vfat file systems in artifacts
  depends_on "openssl@3"

  deny_network_access!

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for github.com/mendersoftware/openssl)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-X github.com/mendersoftware/mender-artifact/cli.Version=#{version}"
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
