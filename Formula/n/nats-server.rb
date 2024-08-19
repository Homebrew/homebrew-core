class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.18.tar.gz"
  sha256 "76982d382fef83080a8abc2e0f6f0f5da9e0e1961eeb78beb18e27a9f458f546"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "046e069d73cf318ad30a459b39d8d99a5a33967663ec16d7c5b2639d5112b11a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a534574b5480aa9d3abde187a6d58b63fde15225e7bfc21ef16fc78d016b9b3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ac5fa18503eeb7d8eb163e0aa9c19b08155da644b592e6b7dd3ec37ede34113"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e4bf33a2078a5b0f0d08707d96fd6e735cfa40a2185ff433f04b8cee728bc45"
    sha256 cellar: :any_skip_relocation, ventura:        "61d79a48d06e84c709724e28f3730fafe694ff7ff382529ac4cea83d2a1eca8c"
    sha256 cellar: :any_skip_relocation, monterey:       "3b431f35689ee8678d0cc9285a0edfed50ce29627193d3ca0b4eb8b451ee7927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6efa13cba574e0efcb874eabc0a829c85b189f901fcbdf928b30f904aea6147f"
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
