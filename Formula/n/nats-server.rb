class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.16.tar.gz"
  sha256 "235b8fdd9a005e4bfb7a14752e4c171d168707662fb5ed00ed064641c8fa588b"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1073a49b6d678ab5bc9b47aa1d152e6dc7a1d487590515b403055143083d462b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ac8b86ba1ed323de3b4d5178a7cb9d038a441df38434258c23ff25661ad26fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bc63ae6a3b9bdcd95cef56904d9a927b8f270d9c3c2a9504e5cfed4ca6f2820"
    sha256 cellar: :any_skip_relocation, sonoma:         "31c3dd652a19f8dc7cd5b1f45242d6dc636a999a6414add30f7ca419fe417ecf"
    sha256 cellar: :any_skip_relocation, ventura:        "10af86596688a02c5012cf0e15c82d0889fcd1e5dcea5b3dd5ffb87c4b6bb483"
    sha256 cellar: :any_skip_relocation, monterey:       "ebf6956aaa5f6b5115fae669ef6d192666fac67cf477ad9b4425b1401f50ad80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7adaf5632dca49ca3e5ae6d7f4b6f13a8e862e8f6d7e3e9b68d45ba118183681"
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
