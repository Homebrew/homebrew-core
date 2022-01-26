class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "3feab6c0d3cf997cc39fc5d0ae5de5eecd70de0d4fe7ded6af120fe721cffd15"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66c17e707563499a12fd058c8e00012d81d89877e378f7c373452fd5c68c6943"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48628ec48eef41d6d96d59d1de8e92c3beb4fcabd0f10a20bbda8a765a2f2b0a"
    sha256 cellar: :any_skip_relocation, monterey:       "6f58de4cfd0e0a836d4aaed79528f8103dcbb86b292139da3703095082be7f5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "253506279ac1f0ac433dff97714455a21d9216cccd75779512e161d92be0d4eb"
    sha256 cellar: :any_skip_relocation, catalina:       "f7b16b78e16e3400544da8c4c5f81eb1d6f88e84e0066d1dafc80383fe8501d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "377b59c1066557d70e963b44ebc0f1963f6f1daa244105243cebd74069d80e05"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"nats-streaming-server"
    prefix.install_metafiles
  end

  service do
    run opt_bin/"nats-streaming-server"
  end

  test do
    port = free_port
    http_port = free_port
    pid = fork do
      exec "#{bin}/nats-streaming-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match "uptime", shell_output("curl localhost:#{http_port}/varz")
      assert_predicate testpath/"log", :exist?
      assert_match version.to_s, File.read(testpath/"log")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
