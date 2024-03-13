class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.12.tar.gz"
  sha256 "6ed770525c68775507b499c7b32a4545c430b929eb657addf759f350e9cd5e7b"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ece0e6c3738c119652f3deebf66c4a3865d8120f5cb05a0db1e0dfc4c354b33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "414ce71436c132023040b6fc2698ddb348969ef95da73bde0a929e2d30205486"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4ef0d1b1315478cd4a5e0c9e9c6c27c91f0e922caca0b342f8f7bd911f6fa28"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0cd13108439b6ef407de8517c74fcd4e7870a7b5c59c528bcfb17dc051d91a4"
    sha256 cellar: :any_skip_relocation, ventura:        "9fd2e6c1e59ea69de5d705b9c4206624f7a107d8ab4f4ac7bfb6f80ee83ee0c8"
    sha256 cellar: :any_skip_relocation, monterey:       "a3968bf0f4577e3d255fd54b44e5f8c971dbdac454cff6ece0217ee8ca9b4aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edfbb8d3a629435e9f0538a19c6b3d547f11a3509f177a5c07547fb5f07de055"
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
