class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.3.tar.gz"
  sha256 "fe53f42a724fef1aac1ab09e3187dcc82fd3761b07960a04a168af767b9b955a"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed75e2f0952e05798f01df69b72832a67b08607f550fde419b2bb46c9081e5c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35e9097d21dc61b8904ee130b08fe65c9015a28baedc7f76ab702e75c1591c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "80b1d25fd10222c0413cae58ac95acd346652ca9c92d58cfc133b73ff3113f0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "29fbdc5df391aff3b9c5b4a44cc5c073df0627b244e70f1161922925e466be1d"
    sha256 cellar: :any_skip_relocation, catalina:       "7f41275b8df4d0b6da642c7e314feb282fa4fe90584dbae6e4dfc1eb4763a590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f024f34c47fde5ea2ba11424bb111e6e4c2086068419288b8bfba5d509244f2"
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
