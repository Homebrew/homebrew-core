class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.5.tar.gz"
  sha256 "375a448077df2554e75abdd2f61821b19cf5740541df6ba77eaba7fac4a4ab24"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d90f5cf73a8516cdc329eb9fbcacfbab9c5f5d7bda3e9e62104a4e7d05b4134d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5884fcff8fe86c957841056a0f9470066d608e121bbbcb89def37673db0ebdc6"
    sha256 cellar: :any_skip_relocation, monterey:       "e5f526e5fc4ebe447905636ea6daa67860ca84529837e9bba5bb166bf1fcb15c"
    sha256 cellar: :any_skip_relocation, big_sur:        "721217e39c58227a1fde9260637b5b6ff453bf53db5e5cc6e8b8141df204d390"
    sha256 cellar: :any_skip_relocation, catalina:       "97622f1bbcf3f311204307b3b1819f71970842c601c436a46e4a951262264835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7928389f214433ba24a0d6d8940eace0f35a26f803c091988e90eb20ca31243"
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
