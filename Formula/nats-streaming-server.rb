class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.24.5.tar.gz"
  sha256 "f648018ca85e4d2e9e53b2c632ff5435825e18ea1306e80c0fb0f59fadf999ae"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fc3d9014f029fc8d61611af7cff3a241839c24eee6c89d2fcf385fbfd2a23ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c9f414290c099afdbacee03a8f36a4db077a78cf2e35b870459ac571b1a13f9"
    sha256 cellar: :any_skip_relocation, monterey:       "62ba6ad93813f970dbe3d5429ae161aa1a34fc105b54c8a2e3c2bd6763c88902"
    sha256 cellar: :any_skip_relocation, big_sur:        "212bfa00e41a8d43b0e4324b0c393cb4294a67a3ab7dd7872affba8a66e9f7d7"
    sha256 cellar: :any_skip_relocation, catalina:       "a9c8d6de47a1021aa557ef4d97b3afc25e4d2fed88c7a23e75f94adb6d713f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80d88922e156ab791344b00cbc7ed3af6528efb756220a77823f30621bbfd8c6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"nats-streaming-server"
    prefix.install_metafiles
  end

  service do
    run opt_bin/"nats-streaming-server"
  end

  test do
    port = free_port
    http_port = free_port
    pid = fork do
      exec "#{bin}/nats-streaming-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match "uptime", shell_output("curl localhost:#{http_port}/varz")
      assert_predicate testpath/"log", :exist?
      assert_match version.to_s, File.read(testpath/"log")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
