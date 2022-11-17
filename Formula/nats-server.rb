class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.7.tar.gz"
  sha256 "eaf5fbfac1e5a07aef4d187dce8eabdffc564a60309bf7070694651cba1f5049"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c53eb7cc03da56223421a005a847411a92160f385bf04c95e58225e76d8b048b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b052e4c1052a36ba6f52ea4ae08cbba481c27cbc7db2c60c19f2079292c2ec5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5c031b44d5c331267c1c74b567ddf2c4f91b5822bd70621d5dcc4c9b511b103"
    sha256 cellar: :any_skip_relocation, monterey:       "8be169510874f69665754fdb864037ff52ae535ea852e5ac282878220e8b5599"
    sha256 cellar: :any_skip_relocation, big_sur:        "32fc7a9678808a66b3b72ec891d97eef208983bf417558311ebc53cdd8766741"
    sha256 cellar: :any_skip_relocation, catalina:       "b9ac57a640f4472e4ec6ca5464c323396365970deb22c29cabdf70c735b66572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "299f63261b3361276e42674c81e194520326962f265b809c81238c6c8d40812f"
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
