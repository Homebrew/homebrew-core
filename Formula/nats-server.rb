class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.11.tar.gz"
  sha256 "cd5afb9867042ebc62d2eec383ddf7332abf409f462776ec1432c94ec59fdf57"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc8167db14d0dd42bee43d6ec256c51695a29e3836eff8353cd84d6cc304a3c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "525c93c7bde7378a22a03bfee832075e4dc89053c888b90f8bd622693241fc01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac3b999e8d469d3a35f45e163c852d513929db10cf7b4d8fcac845a723370935"
    sha256 cellar: :any_skip_relocation, ventura:        "dc75706d4ef5551d205d48054c6c0d8e73551f320b9bc9f8284ef0639737129e"
    sha256 cellar: :any_skip_relocation, monterey:       "44939be2c092af7b5a6c6c0c423ddda5e662e9fb368a6b5bdc8b56c214df5cc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fefb7a7eb2a30766dca2a116212b2a5819db9d0c8dc626d19b5db72a79fc6b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155c131f419e823db95afb1248fa49479b0620125b5a9557e6f72bd2a0347f71"
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
