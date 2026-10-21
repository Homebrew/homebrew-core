class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "41b25fcb78a174f3afce4ec1eca0c1035439abf580f0a0569dbb03bd0d955e08"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56104ea3eb3bd13d25eedd2a096db890cc161aeb06fa350b8cdbe33c58216999"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56104ea3eb3bd13d25eedd2a096db890cc161aeb06fa350b8cdbe33c58216999"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56104ea3eb3bd13d25eedd2a096db890cc161aeb06fa350b8cdbe33c58216999"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f9d15d05b83ba77ebd7a229bb46e5a9e43f777f78f16468786c7008dc34cfdda"
    sha256 cellar: :any,                 x86_64_linux:      "6b09d7138aa2f115ec7934eb964e0105f34ad6a0f3cdf72c8bc7f952c2d3c0d7"
  end

  depends_on "go" => :build

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    spawn bin/"nats-server",
          "--port=#{port}",
          "--http_port=#{http_port}",
          "--pid=#{testpath}/pid",
          "--log=#{testpath}/log"
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_path_exists testpath/"log"
  end
end
