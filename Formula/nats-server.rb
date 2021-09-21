class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "7abee196040c4176d0ae24d0e6ae66807197bad0998069a8095578934a2bf85d"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9261b328cde6c7723cef7acd7c4eb735fe1f33e935ea66af5ba931e4bdecd6e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce610dd2ed75113985db8059afced38c443ab236da8a2ba38f5653cbba3e3f32"
    sha256 cellar: :any_skip_relocation, catalina:      "248ae0c76173f508d5051c7692b05dd9aad449f1700df4ccdc77b3f9b0183666"
    sha256 cellar: :any_skip_relocation, mojave:        "16bd39e040efc4120da38f834141ad99af8a0e03763f670309bd9b494959f557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6815dac5de57f1ed4807f3a2a7708e9ff28302b61e81bceaef49411e6450f95"
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
