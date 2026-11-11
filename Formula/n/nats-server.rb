class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "034a2a7535d67ae6f28962976a530dad1bd912dd2d9af05a3990f3b7e674008e"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "274dbbe90ac2e5b037a5eb8818df8af5fb6e2d0ce447d59daddf7aa893d710a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "274dbbe90ac2e5b037a5eb8818df8af5fb6e2d0ce447d59daddf7aa893d710a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "274dbbe90ac2e5b037a5eb8818df8af5fb6e2d0ce447d59daddf7aa893d710a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9958595292b5d9f0ad27f0c2811bf357a2c7b6973ffac202ade47b9a9d12f7e3"
    sha256 cellar: :any,                 x86_64_linux:      "bb67741e6fd0fe0337b7affc002635ddbe25422e269bec4096c0afa0079a2f0c"
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
