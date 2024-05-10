class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.14.tar.gz"
  sha256 "4555f457b1039265a4925b7640376f97281b401c4ffdc9cb197d708e7066d1f5"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67aa829006854692bba73dea68493134677b4059f7fcfcfb3d4c73e3d6548699"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1020df79c7886551a6d7fd7fdbdaec245d26646bea5450506ed2fd7a6c162dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fade9377d7e1a72257a1f47e2c480df70c913ee6e2aead966723f7ccfbd2883"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed38ae6f12cbae628793e514731c2f8272918b65b4418450159eafb18e92bd38"
    sha256 cellar: :any_skip_relocation, ventura:        "fc35ba222cd1bf252abc5ba927158df9fc0e06e4689af917e4716a688276421e"
    sha256 cellar: :any_skip_relocation, monterey:       "c21aa9ebb01194edbaa61f53fd8493dc37e8223198f581e39fa210a65dc6466f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af3142eb42584fe429ed16d7b7b715cc2726f37147474089e45b934145e1947f"
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
