class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "f59baaa629152ce9dcbb3a4e2ca72ce1275f43b1c24cee7d54b53c58534fa30f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1b35c722c8976e92b4eaf9ef9dbc2a158d073fdc0092b0d071fcbe1b233bab2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99dec3ce3bfc946cf73686971ace44f8a893f340809c3ed311e6144108b5a320"
    sha256 cellar: :any_skip_relocation, monterey:       "1435ba292fb77b3e9b0fff755dbe3d822831af9efce42f64845a4f24ffefd2f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7134bc9ed278cc73c664a4a350e8beac7755d5b212a4273ff06ce69a923bee9"
    sha256 cellar: :any_skip_relocation, catalina:       "db44e6635bf0ca57ffda7fcda6d84ffbf5b12df4134a3a8ca0bb3fd7ffdcb325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b1022dac06d92b1aae432f7ff2773ca45817ae6eb485ee8589c57d0b8cae22"
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
