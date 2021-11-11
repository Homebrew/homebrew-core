class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "bf25c099239f1d43a316d63d79f552dbd86f1b23bcb8e647d11d07d231be5dfd"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c93e366145291bd820767a920ebd1c933dc3d842133fa5ad772bd441a6ecff52"
    sha256 cellar: :any_skip_relocation, big_sur:       "07b8e72f00db316b5dd144a1d0619c7afd619a6389aaffde1c660eb3b3f2e35e"
    sha256 cellar: :any_skip_relocation, catalina:      "91686d2410d5978327e4b67ad4163335e263168fb2efd9cf34c7954383b9e0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c08a368c5c5c3148bb36e8903d42689bc2fee808c28d3015f65691fceca9452"
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
