class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "0ab36c8007bcd7db043391d5660d6ce54c290325857f5ead9961a89614765c0c"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d0d490889db1d7c7edbeb54d0b7e450ce79361a10852f866de9940be96b8e5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1200bd49c807f3a07be9d784b91484c5c176d471e459a0b09e25bfebb4fe3882"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13d6a6fa80292195a80516eacc63d879cc26c3bc001314377e5879e05ada0050"
    sha256 cellar: :any_skip_relocation, sonoma:         "474df8b2af8a2836db88be73c108fc3966983c45438b3158e7f574cacbaf515d"
    sha256 cellar: :any_skip_relocation, ventura:        "253f5da65e0b859b7f1e9714d0ff0ee5881fda006e0b42dd4950591d95b7ef93"
    sha256 cellar: :any_skip_relocation, monterey:       "afdadab3217b5960c0f94b98d3a67c9b2cfa74d2a984c0f60d4686ac04668475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b8cf51c2917032bcf4bd411b817d76eb826fc88e9af4992ee2ba59a015e2703"
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
