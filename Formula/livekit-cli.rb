class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "a09e0ccca7538968f6ad5052a35aa1b9032bb79fc67805e6ba8214ad3ac40c85"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af845f6d40420673308a136e7c3309d8979d6c895594b66efc4af3a9f4b3bdde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98d384ca5de4db1055c14945da7b7958e2d2e6d50f0a1a7c0cc2618b670446fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c150e911595879932b6c0294c26c11a2c83ebbc7e069cf0eb3b2eb6f413c5e3a"
    sha256 cellar: :any_skip_relocation, monterey:       "7f5b62d950832c7df0c5a825aa2fdabfbfb1803017566d091664711785cb7f7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "78fe2dbef688a527011ee082de2aeee26c9ed74180424cd16487d2ae953c6a1b"
    sha256 cellar: :any_skip_relocation, catalina:       "7920efd14ab088f7a58b113cbeb6df880aa8fb321a2ad58269b9e7f50bcbf09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8226166a845dabd29649937594840e10fd695ab9fe1ddc78feac0930f4ea6b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
