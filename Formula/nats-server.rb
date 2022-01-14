class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "fed09a8466878bb50e441fe75745aeaee9c6d2f3fa8cddc29ff8fd15ed7fe03f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "839477b48089da908c84a99fed50b870ed2ea30949e6ad409d3f40dd85131f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47307151c06486a84c321cebf38d98798cf67e4618edfcd516c85b969e1decac"
    sha256 cellar: :any_skip_relocation, monterey:       "8a26425e912d2c8bfebf03d8006aa2a40341c17953c31d91d082a77b4bf144a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a9b8a1ad5a5e7b37d6875ff1a78dfdaa69a2883dc37560e08308673e1fa4b72"
    sha256 cellar: :any_skip_relocation, catalina:       "831889409ee91d024fc8fd2f8ee32f6bdbf932e7264b3fca11be7202034a3c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83ebb3054d4b2104657ca528338e00316478e8cf3b430fc410bd305f778d0028"
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
