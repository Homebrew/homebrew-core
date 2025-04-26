class MenderArtifact < Formula
  desc "CLI tool for managing Mender artifact files"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-artifact/archive/refs/tags/4.1.0.tar.gz"
  sha256 "d82cd2f802033d53f2e947ed8d9d6cdd7a036fadbd92a2696b72122bd2070039"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4924ce544d84988a4dc0de898d58398343df8a283099105991ab425ecd2a020"
    sha256 cellar: :any,                 arm64_sonoma:  "c4fc3d5b4caebb7430d2c336012790b3a5ec6fcdd0ca3a12c0acbc33e15ca267"
    sha256 cellar: :any,                 arm64_ventura: "3b11b89f5db309ede3ba5c5f76315e340e84b1f19eff1307c763af4192f8861f"
    sha256 cellar: :any,                 sonoma:        "56270b60c05f2f65ec4d655a2e21a3f0602b21bef7818c28fa5e8c96ca13526c"
    sha256 cellar: :any,                 ventura:       "a4aabaed06b8519d764028645fff455ea130cb61b4a107e418305b17f0c5cc98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d5a2706c7aa1685a576552abc4620468f311963d63c15a4aa66d0041c805588"
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
