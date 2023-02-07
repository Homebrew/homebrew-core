class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.14.tar.gz"
  sha256 "ed5f116c1f00a687b1209e4288d3d43c1f345b4c4608449d6fdb065c98d0c497"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "446d16ed7c323cbbe402fc0746e421113641dbcb53bfa212ebfa0f610e282c1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "173324f5c4a5c07bf9c7fa475e9f1f7ddf17d1a8bf17aa2e7a7d6b12e736c61f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbe8803657b6bef8ff5bd40728a3a889157dcdb7b2337a183b9397d5552b4677"
    sha256 cellar: :any_skip_relocation, ventura:        "00c9998021c5cd14a7eb189c1dbfee202123fa1ca70d15b16fbdf260d0f573b0"
    sha256 cellar: :any_skip_relocation, monterey:       "6944f7d328520d3f4d7968b5d8b2f38db8c461ec3f48ac896a77a6dd94628709"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3ebc16feab50e8a5ed32089543b5fcf85db3c9f60c6c8d2cec3eb45305e2755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58730735ad1dca21a689edf8836864358919322d467f4d2b97bbff1d670904e3"
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
