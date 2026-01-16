class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.8.tar.gz"
  sha256 "5f9bdbdb4e2654a285beba4a3d3f07d56ea062782b17984364d897cf8fc715d5"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b360670fa7b6b32dcd7545ff930a84554b6b59bb72bdc2f8971fee587a89d1ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b360670fa7b6b32dcd7545ff930a84554b6b59bb72bdc2f8971fee587a89d1ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b360670fa7b6b32dcd7545ff930a84554b6b59bb72bdc2f8971fee587a89d1ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae874aec92f5a81ace4276758424302997d30553a09480cc6db483020fa2e72f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9440dc623ce47e7712e99551b37c7bd79505648f730ecfa9bcc1700a23977af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40d61a01713fc3e17eae9dc2671a139491dbb57399df7e09ef82bf04db2fee1c"
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
