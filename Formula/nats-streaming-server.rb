class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "f59baaa629152ce9dcbb3a4e2ca72ce1275f43b1c24cee7d54b53c58534fa30f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe4d9861829d5741b086169d2e14b1aa0346e285903a138835ff1f7a8b763ddf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a952f90dc4c3085629ed0ce8f59b9be3e230670d5e7694adc15361691ab65c7"
    sha256 cellar: :any_skip_relocation, monterey:       "5ff7342712f7501014a0ef41e49f664ccae69a6e90a5469920892a060e921f47"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceb2432c032aa6030b647d37fe59fe95b9348a669ff59b9a18c45b825ec73a43"
    sha256 cellar: :any_skip_relocation, catalina:       "ef257bf5a7fd1fdacbdf4d56b9ff1393e3b344e9a5b3bbff7cb8c6c311252ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5edb609f2d3d5fe1c695489623480b65fa5fed2e8077039da851cde5b7470e11"
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
