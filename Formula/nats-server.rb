class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "53acfcf144817a77d4b1a6900a817aed2c0d779a943adba804b2dc78b63793bf"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a78694f34cd964af97c44bf81984f6ee26a8c878c44f690d0d5b9f4a08c6ec6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45fc9de8c8b5684e132802dbea43e3195286a46a77a3e585a9051d5cc157793c"
    sha256 cellar: :any_skip_relocation, monterey:       "e23f6fe354b38980f5847b385a746739470d8b3b5af88898e3da8ab8401dcc08"
    sha256 cellar: :any_skip_relocation, big_sur:        "73d1cc4b12081364eeaf7368a276c7c1f498f29ba8b7f56c7ad0bede4754a24d"
    sha256 cellar: :any_skip_relocation, catalina:       "531d7eccea2f6bc9fb815b7b6571aed361ab9a36d5f6ab170a72fbc297d49139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3ce2b844fdff782b968322700a85c0921c8a61b91f2baebe59a527f0efb873a"
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
