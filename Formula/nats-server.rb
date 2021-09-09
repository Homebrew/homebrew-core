class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "6c0274798a63bc6cc8e9c6251cc615d55e58352b0c3124feb9dd5a1b48b6b4bc"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bcda8d0429084ebcf76af4d0c4a10222e1d486e08bee9a6f13f534465e04e8aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "dfcfa6c75fe835bde1cc35cea4df269b171e8088701dfef4e51b1e455ad0e404"
    sha256 cellar: :any_skip_relocation, catalina:      "401ef2d53a0db24e2c0fc6265d515c4a250505560a844392bf9e9a3b62b104f0"
    sha256 cellar: :any_skip_relocation, mojave:        "49ef5eb4d18451797bd79f0c396cd03489688cbe274677fda4bb0a407a11b2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "738c2c63e48b09d0a99fef30fde3768aa7426611e79927da2fe9afa530782811"
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
