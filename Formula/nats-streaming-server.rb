class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.25.2.tar.gz"
  sha256 "f0a8baa9770d305c11b425a57383c8c0fcfa59836e30010aec19c14e54436b54"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ab68ed5a2e3f798180efddf11fc983dd144e008579abab474c3da84881349e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94bb667e52dbd7fadcfa1efcca2c92f4ba54395d04b2d79f521244832c4d9d3d"
    sha256 cellar: :any_skip_relocation, monterey:       "1979ee5de7edb1a5b4133bdd0563974a2e49313b87b539f2f0396faba6e93831"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6604a421c7583d547927c5a5beb7f955664da49cbf51707c594c780b0626bb8"
    sha256 cellar: :any_skip_relocation, catalina:       "aa9c7fd64d91edcf6d59badded667c0f52af54ed298c0553f38e87081c04d089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a8b5d70091889792474114d396c384482c8d2335933c7434e9a3a3c55540af4"
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
