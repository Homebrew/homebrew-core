class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.8.2.tar.gz"
  sha256 "aebddf3f65249dfa94521270ce599eb0af2855c5f57cfb5576f8ac0caf74822e"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6daa57b7acc4bb5b1b8db3c761d31d383ca2ecc0aeb817d5606322fc4897174"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8fc698ca698da74ebe187f759ba0f86db0c9bf00c5d7b71fe674aa7469b9600"
    sha256 cellar: :any_skip_relocation, monterey:       "5c36eb066f972a8ae97eea7f4556ba3005e2164334a0dfc4d848d9c7a7fdcf6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf1d0cf7a8914dc36653b27c08cb64cd277c63d34bf6a6b4668dcf41af770cb2"
    sha256 cellar: :any_skip_relocation, catalina:       "3a31e407cb7f283674d044a577d28ff0c8a2d42f6fdbb956a10b0c327c5bb300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fad94e89b0d83abc21369cbd155cbb807ec6fe12764c8e9835a0061628b3141"
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
