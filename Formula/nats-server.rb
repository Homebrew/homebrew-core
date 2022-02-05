class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "30571297a2bfbd014c867513f0c79031f444b5112c9c0026365f2d82fd71131b"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95120165fbe58919d6c17546a07f908764a7e6e35702396e9483bc69b1fa8339"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c6ee2a5cf326e0db9ae415f264b91d1b3d46a94728ed079b6d3df6da3ce6e08"
    sha256 cellar: :any_skip_relocation, monterey:       "d0296a2da871f926c82bbcf04128bdae09328684c923542ccecaaf4dd52c92c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b65b46d685af569c5cd5d689446f5276bf5ed05e478cbc523c6eb10f278d147"
    sha256 cellar: :any_skip_relocation, catalina:       "cbd35445ef7fdc8c8317e6bae0a3831581cf6add47dd031009ede42a3abdac7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7de90276cdde7fa664edf30144819512cc7ffe0f274abb353261774d8fbf6f93"
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
