class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.4.tar.gz"
  sha256 "d2e4e8280b0281daf112e3e4e110b0d92ea4c4d3b0e1ebd209a266815482cbd4"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e30f24df5345fb267d690a4fc30145a8e338c30d8c3aed0b76ad3f2a0a41786d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "279f15df1b7786aeddfef6d194fb1ac991814492eabab9587c12eedab1047272"
    sha256 cellar: :any_skip_relocation, monterey:       "ac1b3826caf5262b724fcecf5863907f5820fb23bcadf2748be70dcf8baf0687"
    sha256 cellar: :any_skip_relocation, big_sur:        "55e1ee4600830fbe161e90109b22685d50701fd78fa75a4f1865d741c7236bec"
    sha256 cellar: :any_skip_relocation, catalina:       "3df4bbb6231854baa2aa8bf2e602fb52e23991ca3c9022c6e6aedde32724a1f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b25086ee2a91839729438d0267107a707796707736dddc13912f5955385814e9"
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
