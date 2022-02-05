class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "10219100c587596af1e558d073d66b553a0779bbedb768e11a4f3b7d7934c920"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77cd9d608b8296a90b666d2896f2409224e9bb7d9c0be2b00f692ed005d882e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6102b6debc48eafa8d0cfc15df8167de2342340cd9a19f89c648379e31f53ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "dcbf8f81ba3747877b966679f341bbbad29a2b1bb403c5259fa86e6903510e68"
    sha256 cellar: :any_skip_relocation, big_sur:        "2852988f88b7907955a4bdbb85a285c21ba181a88f99755d852c01dd1d55325a"
    sha256 cellar: :any_skip_relocation, catalina:       "e8b0544916116cb52febe0d6ae0664b025584a85c553737acdb3e60c889392c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b3fe69e1f1161fd2169a084f50f070e1f0429ec43a6a2dcf4442bd2b27cecd"
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
