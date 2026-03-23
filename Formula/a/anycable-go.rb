class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.11.tar.gz"
  sha256 "2039fa9f7f22ac3c609356f11133254991b74ac165054f0668e6683386cb6390"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bc409dedefafd9135bde2e273ce40e4a23eaeca2d8de28bca6a614fcc5f2244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bc409dedefafd9135bde2e273ce40e4a23eaeca2d8de28bca6a614fcc5f2244"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bc409dedefafd9135bde2e273ce40e4a23eaeca2d8de28bca6a614fcc5f2244"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cca684ce83b4aa0b3ef7226370485476723dcdddce12a9b6a2eb29263b39cc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "277ab9111455156487eb6c1ab8c1f5ae7fa1b3f9370ab74b8dae982cc5790a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35ab0ec117e59df04623e8ac5a9b7bc3481bd590de44e67c44f3243fdcfbdd47"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags:), "./cmd/anycable-go"
  end

  test do
    port = free_port
    pid = spawn bin/"anycable-go", "--port=#{port}"
    sleep 1
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
