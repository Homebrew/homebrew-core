class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.25.4.tar.gz"
  sha256 "e3cb61ce2828909e2c174cdcd00a3a5f49ef8bf45c07a0c016b287ce83bbf8dc"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88f2c1be1f0c1c3850df9b724b7a812590691b9332de18cb9ff83c210145574e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88f2c1be1f0c1c3850df9b724b7a812590691b9332de18cb9ff83c210145574e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88f2c1be1f0c1c3850df9b724b7a812590691b9332de18cb9ff83c210145574e"
    sha256 cellar: :any_skip_relocation, ventura:        "70ffa7b5faa8dc27bd168b7ac121046c583e4e008f7c1867d0a6fa25bd3ffeb4"
    sha256 cellar: :any_skip_relocation, monterey:       "70ffa7b5faa8dc27bd168b7ac121046c583e4e008f7c1867d0a6fa25bd3ffeb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "70ffa7b5faa8dc27bd168b7ac121046c583e4e008f7c1867d0a6fa25bd3ffeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28988a1426e1384cf022425502ba512922f74eb277889cd6c2f387400dc693de"
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
