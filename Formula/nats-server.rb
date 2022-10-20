class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.3.tar.gz"
  sha256 "fe53f42a724fef1aac1ab09e3187dcc82fd3761b07960a04a168af767b9b955a"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc8757e41a86692417cb9eb5ac4a20f069c4c2142f0be5490376a60915cdf434"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98f6f9c002268e4988cdffa4aca8aed19551e7de551f747a390b01a3a10d75df"
    sha256 cellar: :any_skip_relocation, monterey:       "56bd51bfd0b72ac689e31b4268913f788912a27ecc1480fd6fc80d768d5a8d7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfec8015142dc9f1d8eaf27c03c95256631c5a4f0246a4b07932f1807aa6c8b7"
    sha256 cellar: :any_skip_relocation, catalina:       "86daf8dc6ffa7d3d41a823ec030967f471ee54bdb19f9b981cb88f10a3b4ca8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf62df620fdda90a56ae1ca240f73a4c77b09b88656fc5af0c9e3792be42fd6"
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
