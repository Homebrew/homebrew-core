class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://anycable.io"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.15.tar.gz"
  sha256 "f0df891c2c658e05f1504461e66c00d8765e8eb614cf15219c5b07b85b42ec9e"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed4c1454c9f72cf5bcc323651724ed6d41cfb1b7647a5f95232581e9b17845a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed4c1454c9f72cf5bcc323651724ed6d41cfb1b7647a5f95232581e9b17845a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed4c1454c9f72cf5bcc323651724ed6d41cfb1b7647a5f95232581e9b17845a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6d4a659055a7a02e5fb405cdd2eaf92d0e0121e48a21c9b4d597cd2f414ef19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fad069e41fd12314407d417c712eb27f66966626115eb3e615b27def904347c"
    sha256 cellar: :any,                 x86_64_linux:  "6fdfc4a687bc61cf93920cea5b3c8e732b042fe638b31ccba4630207a5a76477"
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
