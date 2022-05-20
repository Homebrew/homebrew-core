class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.24.6.tar.gz"
  sha256 "750e091f3473688a1b0c251513bf9beb7a12e3e1359d541b53381bd91e09b9be"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5acb964e918c9c39ac0f6bd7d8ddeb6dff13e492a69a3930532382f331543403"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57ec652026e19945c61f645d16ea0e381a8a51d090507ba4f1ee749d641b2b3e"
    sha256 cellar: :any_skip_relocation, monterey:       "851c8e68280ed15b2ecc1b43128a27ddf3ee60260bc4befec4d49fe905d8a352"
    sha256 cellar: :any_skip_relocation, big_sur:        "2faf7fcca36d51e50500cdd714af091b6275928d86042358747037b694bafbf7"
    sha256 cellar: :any_skip_relocation, catalina:       "3f13def42236d8b66965b7efce39bba963ff54f30635428e5f90818f47e48ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65350b37f1c99b651e98103ae68e4e978d0589fadef5bd541f71dcccc062b1b3"
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
