class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.7.4.tar.gz"
  sha256 "4a98e3ba5022f55341aed7c07b6c61bd93be82de76ef03758825ca9d53310e6f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbd04df771c8513f28596127cb75cb765fb7c8b0e265e58a2ed28f35ac82bdfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61c0551c0aa1317357c3e5e55088e05435f0a05114852734f5386b12d9609090"
    sha256 cellar: :any_skip_relocation, monterey:       "1a0886c24a4db6ab4abf19d5b07070d557efa6cddd385ea0b0aa79aab316eb72"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd00bc0830bb84d708d94ba70d2dfac5325324b6932e5a514cf5566167d17aea"
    sha256 cellar: :any_skip_relocation, catalina:       "a1a2311ee63fefcf3a8cf0da7057991a653b77558f8cfab99fe6e57deb1eaf4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7564c906d9bb01e944b74e11841126483ac8e786bea175f0069b741c7f0c0514"
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
