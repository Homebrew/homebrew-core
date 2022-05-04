class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.24.6.tar.gz"
  sha256 "750e091f3473688a1b0c251513bf9beb7a12e3e1359d541b53381bd91e09b9be"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f82751162c8aaf4c5e1ad2d22a0325666c5fa146f269cf571bb8642cd5a3e03a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a52f969ca55271f163973afa6330d9e98a3b146cacfa7ebccbd00501b0dd50ce"
    sha256 cellar: :any_skip_relocation, monterey:       "ba61154112c17f10595ecf53535de278b74226ed76796199f3c07d485017c50f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4578c65790c2a9947df776749eaf1b70807eaea897d48fad7c6c979fa24edd85"
    sha256 cellar: :any_skip_relocation, catalina:       "d6cb55becdc23b57c3a9935fbc5c5b0e2b3c87967311ac36a28f87daef646169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30dc5d8cec36e2405ad66ccca1b7bb3bf5a80f60798166e42ad91e8a16517f7"
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
