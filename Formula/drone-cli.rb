class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
      tag:      "v1.3.1",
      revision: "19b11812d38753f6a6d4a185c465ba26d646c5d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d78b6434793f9d71b197330f7bd1e021d9a6c348700d2d518daa8a348288ab6e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce7174f76b2f79ea085e3297ef10f01ae13d057c84133079da16e72ec91563c3"
    sha256 cellar: :any_skip_relocation, catalina:      "a3bb9a627f909962bc99c5248b9b211edeb848bb758f1adbdf8b65716f6f6dba"
    sha256 cellar: :any_skip_relocation, mojave:        "0a5e2ff711da8547c2466675fe42104015b6032702db19ae4d0688646b72dec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56442726986cc75e9e1465eca0602bedbc87f5a8d65408ed4f8fa6987499dbf6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
           bin/"drone", "drone/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
