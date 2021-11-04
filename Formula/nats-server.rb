class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "c6712025b9bed326f758954f90d2585b5a505636cc2fd339b0b38776bd74dab0"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2458cd79257ae4827d29206cc6e99dcd134d5b5ff7ba5863c7d59a4c81d37cb7"
    sha256 cellar: :any_skip_relocation, big_sur:       "12c617f3ebd25fb398a3311721eebdd13008364c727abdcb090f4566b9e2ef10"
    sha256 cellar: :any_skip_relocation, catalina:      "6bf2042040c5312e58e9b0047133087f019b14adbaf91388748b3593a27dd522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "171a8ccac2d95c3701d5e36e3aeaa97dc4c4f6976b50a832ac8c8940d1746997"
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
