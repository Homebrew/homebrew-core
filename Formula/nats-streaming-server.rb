class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "10219100c587596af1e558d073d66b553a0779bbedb768e11a4f3b7d7934c920"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "827b8c378ef5d89122ec4c3f1ae63497134119fd6632e6179939e32dd5747e9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef8fbaa3edcf6a6a938ef1749f79925ed991e7f2946a3e070cbb46ebee10e13a"
    sha256 cellar: :any_skip_relocation, monterey:       "146be88d6f28b4be113932fce77a9391437a05087c221ad2784269890be92f58"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a522cdcd1931a41def113b7fd512a7f254caca8cb8edfc261c54700fae30e84"
    sha256 cellar: :any_skip_relocation, catalina:       "ae63d8c10dadfff809581019790b76a8ad9cbe63114d0ad0c29a5caac4711df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44de41aaea8c5c53eeded1232afa29b691923afa1567048fc51d51607a50aa57"
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
