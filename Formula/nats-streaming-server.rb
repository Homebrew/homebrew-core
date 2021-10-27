class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "da7bed2ea1eba6cda2b4bcd1b65ee728dde98370e3b91c007b39dc24387b867f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cc5715a87b9983e3fa80fbb8d13145a5c7c77304c937e6fd17924e3c2518b674"
    sha256 cellar: :any_skip_relocation, big_sur:       "3440420133ca494b69319a94fda74f23e079b1c33488e81d8752631ba83f7d78"
    sha256 cellar: :any_skip_relocation, catalina:      "7333ae25bb0e6556f98d73b0560d2caac4a544115fa5c584c22a80215bb37caf"
    sha256 cellar: :any_skip_relocation, mojave:        "f8c5a35b2b8662c66d8432791bc591d32a4e8ab7ddf73f51c2a510d4b54ccb4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1197d2f94f483dfe14bc47d02a933206fa0a29fb731bacf4a461db676803d345"
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
    pid = fork do
      exec "#{bin}/nats-streaming-server --port=8085 --pid=#{testpath}/pid --log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match "INFO", shell_output("curl localhost:8085")
      assert_predicate testpath/"log", :exist?
      assert_match version.to_s, File.read(testpath/"log")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
