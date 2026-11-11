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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b26de58cd4ef0d95816452785d098dcdb535c6406251d6c7018468f1d4605650"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b26de58cd4ef0d95816452785d098dcdb535c6406251d6c7018468f1d4605650"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b26de58cd4ef0d95816452785d098dcdb535c6406251d6c7018468f1d4605650"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6d890186bbe97c61c08ee6e9e51a80cca7b9c0988274d99eda21c1ac42233a90"
    sha256 cellar: :any,                 x86_64_linux:      "ce3ce429bb902c79a7e78043c0d38fba38728af6aa24023a89070096295c5e02"
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
