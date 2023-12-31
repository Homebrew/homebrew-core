class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.7.tar.gz"
  sha256 "493eb53a7c327af19b455a5a00d5593833d0a2bec12edc425ebc2c826aadcc3a"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1311ca0d6900b532ecbe68dd9639a5a2d555604e2e17a743979661b605b1b77b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f8431ba07120ff1f3a8034cc011b19af3c7ea56c4cea9cea72cf83a72a43a58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0832de4b64b304a6279edf1cc82f47d0362b4a13f3526085c1afd4acf81caf15"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbadde1bdc561ed238ec57a234596361bb83b56bdc287706bf8d38c0ce861460"
    sha256 cellar: :any_skip_relocation, ventura:        "15026c3b52f18665abd4a4b245c3c15a733a97316f679f01a8ef7d35e0ab2f99"
    sha256 cellar: :any_skip_relocation, monterey:       "331f51ef2dea06dbdff4612ac2c3c30d89eda8dd74b956f3aaadcbd421d796cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0cd1923895d26d3c9bf59895496faf1dbd141169ba58e39ecdcbbbda960ac95"
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
