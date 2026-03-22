class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize.git",
      tag:      "v0.24.2",
      revision: "1b7811b7ea17f8a175de13d55d5ebb537811900c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c03de360eaaa2046b25d67d51f12f0f40100c37af8125fd4105eb2de56b75497"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c03de360eaaa2046b25d67d51f12f0f40100c37af8125fd4105eb2de56b75497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c03de360eaaa2046b25d67d51f12f0f40100c37af8125fd4105eb2de56b75497"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b2a0b96f2fdb90e2eb00fd8d5ac24b7f7fd33e70b5cf5d1eff11a8f14b62b3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "789da6f945f97e449374e63c000a47f28caa4819777adccb76e29abff2dc70f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c84b304af3f032e411b87f5750d4ba4a2cfadce7e442877f0bcfe2e056adee98"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
