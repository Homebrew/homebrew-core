class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "58bbd2c7f33b04b14aea7ccf2c5975e1376e121aee77bf75094dabcfed0f3b39"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24d4c3b74e4465497dd9cf8e0459e04b0abf87274c2c4c99a66d8551f32b6eb7"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a98cf8a7b270e149fe4a0bd4309a065fbabbd2639f0cd245e5ed4aa0eb7baf6"
    sha256 cellar: :any_skip_relocation, catalina:      "cc67a59bff3e4dfe6ad8e02ec2429d50ae813fccdcef36273d5ba4cdcde8f1db"
    sha256 cellar: :any_skip_relocation, mojave:        "e68ab829b353b6245f2a3a0b49c325875ff123b3bc67d98d828b0246c8551137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ed6710b25b8c2fffe3fb5d994f3c2f92847e5e01dacae98b2adc61a8a85f643"
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
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{port}")
    assert_predicate testpath/"log", :exist?
  end
end
