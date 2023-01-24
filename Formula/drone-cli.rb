class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/harness/drone-cli.git",
      tag:      "v1.7.0",
      revision: "c75a1a82d46e687d2d961115c849bf3a137b8e9d"
  license "Apache-2.0"
  head "https://github.com/harness/drone-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66172d41d0d98db6f993146668fb40701f2da05a66f9b359ad12ef51dbd7af90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66172d41d0d98db6f993146668fb40701f2da05a66f9b359ad12ef51dbd7af90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66172d41d0d98db6f993146668fb40701f2da05a66f9b359ad12ef51dbd7af90"
    sha256 cellar: :any_skip_relocation, ventura:        "0972102d85e71a67a2488480584d28b118805f68cfb384ec6bdb436c3b1bedb7"
    sha256 cellar: :any_skip_relocation, monterey:       "0972102d85e71a67a2488480584d28b118805f68cfb384ec6bdb436c3b1bedb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0972102d85e71a67a2488480584d28b118805f68cfb384ec6bdb436c3b1bedb7"
    sha256 cellar: :any_skip_relocation, catalina:       "0972102d85e71a67a2488480584d28b118805f68cfb384ec6bdb436c3b1bedb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d58eb66b4f3a159821ddd80051873d60288b0cb3903a2b83f6163e321798f44"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"drone", ldflags: ldflags), "drone/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
