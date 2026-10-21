class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://anycable.io"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.19.tar.gz"
  sha256 "f454522f83e1453f86d20e6fbff54f21519197fcba046241598f58710c5e4723"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05a302902169cf7635a41c7400b6110b09c0391c3f78206fd2cb26b8ddacdd95"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05a302902169cf7635a41c7400b6110b09c0391c3f78206fd2cb26b8ddacdd95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05a302902169cf7635a41c7400b6110b09c0391c3f78206fd2cb26b8ddacdd95"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "92b1070a6538368777365295fd63938a94b9220d4197452eb2a8efafd68dfaa7"
    sha256 cellar: :any,                 x86_64_linux:      "bbaa50eb9def58b18f4adf6aa5544554cfbe759fb0489eb65f7fe97653de8033"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = if build.head?
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
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
