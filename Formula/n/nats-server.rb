class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "54cfe4361aa09a55a92524b737993941cd37fd444ccedd9ba60fc0d4a0c0cd72"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbb59426d60cc88b4357e613bd67192ea83dede0ba23d6e8157878e7fb9eb45c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb59426d60cc88b4357e613bd67192ea83dede0ba23d6e8157878e7fb9eb45c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbb59426d60cc88b4357e613bd67192ea83dede0ba23d6e8157878e7fb9eb45c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f90bd2ef8bb542dac1002e15d5f8f1295b8220544d996ccdcffbe825742a66b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fae63cae3125e47561a22bf46ba297f4ab28449c9d8e1a13c97feb97458b196"
    sha256 cellar: :any,                 x86_64_linux:  "c50801ecb6cf888b9c37b1cb9c337ddb2a76a1360e83f1d01e18109fd2cc515a"
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
    spawn bin/"nats-server",
          "--port=#{port}",
          "--http_port=#{http_port}",
          "--pid=#{testpath}/pid",
          "--log=#{testpath}/log"
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_path_exists testpath/"log"
  end
end
