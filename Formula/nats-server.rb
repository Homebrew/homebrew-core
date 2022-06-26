class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.8.4.tar.gz"
  sha256 "172c5d04c3867adcb6b2322d87d7f7029b63e9465fffffcf99d4ca652820635f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb4a51929a301a6693bf1c419ab59007e67cf85cc807b5a839a510b4b7a7e9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cf17da47a1a5ef20c9feb60eb9576954e31ddece2b3666cf79ba6be6ffdd874"
    sha256 cellar: :any_skip_relocation, monterey:       "69900b5eab7c108efb7d8142e7013dd7a0510f00e414980722e7c4c16e9ddcd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccce5f7a723ead5586c2aeb21e53636d38841814f452351b14932eabd207aff7"
    sha256 cellar: :any_skip_relocation, catalina:       "ed13d4e0ce70db2a99652070489f4234abd7574f2942dc673263499ea833c993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2dbd10f04fcd17e079ffe4786d939d112fc73c78009779af38b1269553efba0"
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
