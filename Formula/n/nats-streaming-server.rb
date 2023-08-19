class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.25.5.tar.gz"
  sha256 "e235b0229fd088e047d3f7313285cc984b91232263f4225cd87ee8a3fc6f8499"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc2ea921b0bd734bb63a655cc2aea6f130d1f500362f5c9ff12e375a9184f715"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc2ea921b0bd734bb63a655cc2aea6f130d1f500362f5c9ff12e375a9184f715"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc2ea921b0bd734bb63a655cc2aea6f130d1f500362f5c9ff12e375a9184f715"
    sha256 cellar: :any_skip_relocation, ventura:        "bf18f46843325128b0ef0f5bb3451840d738a79fb85ad5242eee66587e4ae48e"
    sha256 cellar: :any_skip_relocation, monterey:       "bf18f46843325128b0ef0f5bb3451840d738a79fb85ad5242eee66587e4ae48e"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf18f46843325128b0ef0f5bb3451840d738a79fb85ad5242eee66587e4ae48e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94ad7efcdf8da81e1a9e2e5cc9707f46707252d5fe685434ed20c295531b4c76"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
