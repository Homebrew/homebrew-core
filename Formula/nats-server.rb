class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.8.1.tar.gz"
  sha256 "510c766aee83742190c0ff63dccd58eb27282b6aa292f0e6752fbeafda1d0ecb"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d29331797680533040072342e58ab5eec4ad8a64cd865d3579720907259c4eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "395fdbfe7c8dec13041f5ebd2854907b3148577c7f9e663fc3ab008946b69935"
    sha256 cellar: :any_skip_relocation, monterey:       "44d684586275ba3ec5c648f0706172883bf9b60b1e148aeaf13b86b5460fe15d"
    sha256 cellar: :any_skip_relocation, big_sur:        "62043d768f0d309943f6f6fd664c12516180a1e2aded2486512c7a375e8f0e0f"
    sha256 cellar: :any_skip_relocation, catalina:       "1020cd310697935182f9142bb58f4b294bd4b1430b49adbc6f03d82f0a1f423e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b91ce57b27c233e9dd62a1734fa1d8d800475e3256eee8f5ad63bb3bace349a5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_predicate testpath/"log", :exist?
  end
end
