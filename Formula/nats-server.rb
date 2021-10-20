class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "fbbad2370bc92a548e9a797b941c79b19d7affd5b1db622229afbf043f9932fe"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5b9f7c0de5cdc2a784e453908d805a8e6cecf9d34a91d8dd9a7877932d67f405"
    sha256 cellar: :any_skip_relocation, big_sur:       "4461e1a0bc9fa66646cbcc3583d862a287f04387054b107f3b6f07d75a80a847"
    sha256 cellar: :any_skip_relocation, catalina:      "72eef3399f71f26feaf4a6500d7569ae675970e8735484cd0b9ad20ea280732c"
    sha256 cellar: :any_skip_relocation, mojave:        "4925f401f36d3d77bdff0c569190a75334215935bdd3054944c041d94c7c026f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "696507c0e4663052ea6598915bebb650027131c95623233067fe65aff3082d8a"
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
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{port}")
    assert_predicate testpath/"log", :exist?
  end
end
