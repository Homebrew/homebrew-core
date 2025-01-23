class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.24.tar.gz"
  sha256 "64093d74f81ad92d466f1a0de119cebe455db1c7acd2511197a497fa85b8baf5"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "862ec9c77bb6a9337a3cb20341aa0eb1386127f930c01555249bcba58f5902f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "862ec9c77bb6a9337a3cb20341aa0eb1386127f930c01555249bcba58f5902f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "862ec9c77bb6a9337a3cb20341aa0eb1386127f930c01555249bcba58f5902f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aa5cc8def31c0018455807c41e62161549938317ac0cd543f019e8d7cb47fb5"
    sha256 cellar: :any_skip_relocation, ventura:       "2aa5cc8def31c0018455807c41e62161549938317ac0cd543f019e8d7cb47fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95bc3220c971a725b090661391b914aee02adaa8db343e24da6bc6dbd8b5fe00"
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
