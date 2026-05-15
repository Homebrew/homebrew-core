class MenderArtifact < Formula
  desc "CLI tool for managing Mender artifact files"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-artifact/archive/refs/tags/4.4.0.tar.gz"
  sha256 "b8eb3b3257e5ebf64ea9775ba475119330df8b66013fdbfc003d91dc4492d974"
  license "Apache-2.0"

  # exclude tags like `3.4.0b1` and `internal-v2020.02`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fab320846f550f1656c35899d2727faa68ccfddf99bece775aac993c089dbb93"
    sha256 cellar: :any,                 arm64_sequoia: "780e955fe45744511e6800ebf0c759664c28bbd3f932b8e007b557349a93f079"
    sha256 cellar: :any,                 arm64_sonoma:  "311862da0de84c407fc706e7f52fe91da506595431475c9e4928d6631ff92098"
    sha256 cellar: :any,                 sonoma:        "aae1cbc9056459a8dd9a1cca9027adf283083e960811ae9630fab95c44205f2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a112a4ab7d9b6d717f7bc2515cc7f7a6e8f8b98cfdf30f52bffed713427f3bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ae819c2308d01379abfabb3099ffc7843b1a2b3e1257542e89767f404f256f6"
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
