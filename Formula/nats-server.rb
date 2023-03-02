class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.15.tar.gz"
  sha256 "e2f63277776886134683ea08d0f9c39c0e93161b483b295d84180d02454bfc28"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "090e22bafee2150d61a1247b56752507df55ab79cee28e7e6563b2d0e686ca5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d6cfa83e46dd09bc1185c8db4cf9e8b1f2cdebf48d432ec0c6a78dc7c1218f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbff5bba3cb8ed073032536adc364b5274b5d4d9a7efc0c001485d051b635af0"
    sha256 cellar: :any_skip_relocation, ventura:        "0c3738b4e65366b3d255a3b136fc20705082f9841adbef2c5ee472f2393005d9"
    sha256 cellar: :any_skip_relocation, monterey:       "15c9f505a9e12f5874ae79535d12827acc00a6504b8882601c89239f1576f814"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2c4a71b0ba50a8245d7e02506686fa6b56b6c6a49d4dde07275751df1705f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd03df25964d0a241a8cdadb9243121cab66918f7b486067a0bb932c07b6a89c"
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
