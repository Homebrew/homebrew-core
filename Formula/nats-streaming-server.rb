class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "116035f0c3c7e6154b7b1352d53ab16bd90b89afbce4afb70fe5d686ca4f24b0"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7be754512246cbc8d4b4885c94eb8210736b0794a98615e7fe006e31e7b62270"
    sha256 cellar: :any_skip_relocation, big_sur:       "cebeb9cf1dc610edc6ebe295618e83b64b8afbffd5d2a8451e10d6a22bba9394"
    sha256 cellar: :any_skip_relocation, catalina:      "5c160c9dfd4652d8eb58a975641968fdc302b60fb1a43a7c864f5a4ac0663b24"
    sha256 cellar: :any_skip_relocation, mojave:        "81e07ce9a896ea551e332bb831ed5d05282f4a7865377f41837330a567cb2c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7df96690d23eb8bddfc8acee69810ee712568f81d64e53fa0849cc168420a72e"
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
