class MenderArtifact < Formula
  desc "CLI tool for managing Mender artifact files"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-artifact/archive/refs/tags/4.1.0.tar.gz"
  sha256 "d82cd2f802033d53f2e947ed8d9d6cdd7a036fadbd92a2696b72122bd2070039"
  license "Apache-2.0"

  # exclude tags like `3.4.0b1` and `internal-v2020.02`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d9c42ade066c950f156d48249363f17ae1976ac3a4ff9cd511cff92bd57b02c9"
    sha256 cellar: :any,                 arm64_sonoma:  "64a6cdafadb4b633f303a00fe2880fbd7a450a85c9586b2d246972c600917ec9"
    sha256 cellar: :any,                 arm64_ventura: "b91a6a9767b4847fb9c954d1107b9b072f906137a767b22562e6faabe355e155"
    sha256 cellar: :any,                 sonoma:        "515fbdff1f6d0ff7bbfed64647309df28c9021dbe2e85d80332782c2a30089bb"
    sha256 cellar: :any,                 ventura:       "340b7365db24c4a352647eb37f50c589464585ac7d12b54ebab8037a2574a39e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48b8f124a177b145ddea1a11bcc974408c634113177f3b4341bb758016c5fc55"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    ldflags = "-s -w -X github.com/mendersoftware/mender-artifact/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
