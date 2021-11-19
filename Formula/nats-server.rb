class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "7d2fed3db144523c4554833412d352f2fba7ddf295dc7be13a3c0739f925eb18"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "179b73cbcff7bb88e4353f13401a5093a0e4b46c7dee8fada0673ca546f3f011"
    sha256 cellar: :any_skip_relocation, big_sur:       "12ce553356c028342e55248813941c9631270410644ff9b0852bb01ffe792864"
    sha256 cellar: :any_skip_relocation, catalina:      "35f26695f8d16887c40b9fb02fd1d707b6fb933e222195bdd4e57f8b324ac65a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bafb06566fea687f3ab6a5ffa5c098257a96704e9e1be6e43929a08471209f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
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
