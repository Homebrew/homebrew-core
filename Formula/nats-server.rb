class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.6.6.tar.gz"
  sha256 "2f906b7dff38dc470ffcbba26632137f19282afb874cb173fc2dabf72359405f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7b3909fcc8f0ae9ace651e073d372222a36ea8fe09b3fe2ef67d0e89e3fae24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58fc00efefbf59e8012989473cd9e43084bb20f267665b2658c2547e4aa82b46"
    sha256 cellar: :any_skip_relocation, monterey:       "04e0ddc41ae3e25f4f6d07d4654e1cc07811a9fc624185a5e60d4d50af03fe44"
    sha256 cellar: :any_skip_relocation, big_sur:        "80cd3eb78034118e016e11000b895bd60857f85395e71017f63d127b1920bbc1"
    sha256 cellar: :any_skip_relocation, catalina:       "de39e6ea7bea66c4d8338cf4bc2d9b7cc4493776b0a9a12339a5359c020e8a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53221a8c8596d059b5b6fcc06e82a394786c548d4e4b9da99d88dc59bc9f783e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
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
