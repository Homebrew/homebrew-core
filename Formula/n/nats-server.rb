class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "24ce9fe9a069d049f6050231b81f2c9e00ad4f456801c002fb9a5bf15ebd6cc2"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34ae7385bbc9b2c2be9b4e2e645a7e8e6dc89dba7a43882aa8065f859508e0a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "34ae7385bbc9b2c2be9b4e2e645a7e8e6dc89dba7a43882aa8065f859508e0a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "34ae7385bbc9b2c2be9b4e2e645a7e8e6dc89dba7a43882aa8065f859508e0a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7cadad342a20ee88a48d457463b63c3cd1fe263fd6fd11ca870e22f930aa144b"
    sha256 cellar: :any,                 x86_64_linux:      "fd6318bb2232d2b0fec9fde273864484a6745bd6eb784361ab3ee0abf32aafd8"
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
