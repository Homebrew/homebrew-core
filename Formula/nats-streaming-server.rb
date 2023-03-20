class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.25.3.tar.gz"
  sha256 "3fd42f75ecf65aa8d5faebcaa45c5fe4a2a1a1d24c8f7d1f5919434f1ccbc3b1"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7595afec85c53398229cdae0a2e03413f004b4d110f2cb73825bc3416aa5940e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31171d17c6763cd8a9bfee3a2dfa4ed571607245a464a74c519ec35c971bf18d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d1bb3527d1a871e05b72bf74f58439682296103a432d087547b500989a2f43c"
    sha256 cellar: :any_skip_relocation, ventura:        "fe9ffbdb0154fb815d4c4877b8d745cc081d0d6e2fe51155b73cea2a96f1a966"
    sha256 cellar: :any_skip_relocation, monterey:       "7dfaf98e147efb8bb4eb99c38a7e5e5e7fe0cfbb6773729e276cdcf369ec2cd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6e01fc372b782e38990fa83e6de446761a9518db696aa99073488672be6d962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f05c2dd715b1999ad21e445cd67a3cf7c4b1f6bd6b5457d9071684f343d561"
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
