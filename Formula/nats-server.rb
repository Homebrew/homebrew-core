class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "30571297a2bfbd014c867513f0c79031f444b5112c9c0026365f2d82fd71131b"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49791c90dff27361eb8b89da7b7d716c0366e33dfea8b8d112bac4d8110a3d50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d81400b750e95bceb71b6299fbfce4e1ca92767133cf9bfe5580708afa3ce11"
    sha256 cellar: :any_skip_relocation, monterey:       "9e49262c40b63338346ac7373c38e45bb81f2cd7107dcf2a42519f6321378824"
    sha256 cellar: :any_skip_relocation, big_sur:        "21324f23b80c51cf444caae7872536bb74dc0947c31c85e9db016a95aeeb25ac"
    sha256 cellar: :any_skip_relocation, catalina:       "76ab697fd4920d519cd60c4049f36c9c4ea4b05d5ab116ba069c6da78835079e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4bf1085b0cc536598c873830e16e47e5c3096dd357e1cb2989d57fa26014700"
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
