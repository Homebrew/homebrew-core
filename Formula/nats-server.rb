class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.8.4.tar.gz"
  sha256 "172c5d04c3867adcb6b2322d87d7f7029b63e9465fffffcf99d4ca652820635f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8336ae4d915424b05b581970da5f3b508c648a15d5f6662a6c090ea359ee46a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffb39caaa17e7f7e3cd6dd3e783b45e0dff4f366f35fa3cb74f13b0e56ece260"
    sha256 cellar: :any_skip_relocation, monterey:       "1f4d3aa9bd34e73f6afcf3eff5333138f5dc4e99c0a0a9ba47efe826548efe60"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8a61e5a296eb3e169b38ce7d06f11c728c25bb273d943062d3ec02639c260a3"
    sha256 cellar: :any_skip_relocation, catalina:       "f1c22e0db576873093c9f7951fa2d7143f6a47fce8f616e667b7c8bec9b64c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa0f28c8c58c056ea28bda721cf3bbb8b71fb561500b29f775200659c1737687"
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
