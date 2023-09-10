class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.22.tar.gz"
  sha256 "55e362ddb4dc121a09fdee9b45beb5552daca3cedc1551899d209d7505f0b2c6"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6a09f774901cffabc7f11f225ccdfa483d2c4e0014cbf75b137d6deb672075c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c8f1331b7bfec03ef1c6b47d131bcc835403a75596156625a485a8cc47ee72d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49d104a1ba15e2c49064b7be0e493ffe5886993a9bff9d9da184e2c1c75f6910"
    sha256 cellar: :any_skip_relocation, ventura:        "c8128c20774de41bc29a635b8b56fd0c665e828d73696ff2f5b73d716e509ad8"
    sha256 cellar: :any_skip_relocation, monterey:       "9f8ed710ee3f28fa861c1d486d93eec705261590999ae48d9a1c5608f33423db"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f9963115db8757eb4574ee1f8566753695b342090489da79450f80f3f5257df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9981507f40a943673d9120f02ac4bae8c51e55c8287df72cb51c458891bd712"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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
