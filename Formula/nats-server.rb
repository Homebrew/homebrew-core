class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.19.tar.gz"
  sha256 "541f77bcc5c71ccb267883e3080e60602ec57a02d9316557346af9bfe4f4193a"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3f40a690febb1cbaaabfd85e177c4e0b5aaf9ba88433ddae67c72ea2213e9e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3f40a690febb1cbaaabfd85e177c4e0b5aaf9ba88433ddae67c72ea2213e9e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3f40a690febb1cbaaabfd85e177c4e0b5aaf9ba88433ddae67c72ea2213e9e4"
    sha256 cellar: :any_skip_relocation, ventura:        "05fbb99be88b2157217aca6846ebb350af717593cc4f8ebf3989063ee8332249"
    sha256 cellar: :any_skip_relocation, monterey:       "05fbb99be88b2157217aca6846ebb350af717593cc4f8ebf3989063ee8332249"
    sha256 cellar: :any_skip_relocation, big_sur:        "05fbb99be88b2157217aca6846ebb350af717593cc4f8ebf3989063ee8332249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df82402286ba4f245c8166bbedb803a7b4743c199caa9b1d166cdaeb9be4a1e2"
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
