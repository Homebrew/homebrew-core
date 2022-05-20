class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.8.2.tar.gz"
  sha256 "aebddf3f65249dfa94521270ce599eb0af2855c5f57cfb5576f8ac0caf74822e"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "041bcdebc7b947a87b7ca544be24121694633d65a851e39e245e2d6b5c28b181"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1f231bb5208dd55da7ecd555700952c74348d474d102385a24849b0764d1867"
    sha256 cellar: :any_skip_relocation, monterey:       "52620d7ec67506c9c7b7c01cf3a625ec9daff2e20d97fa5df706ada577c6a896"
    sha256 cellar: :any_skip_relocation, big_sur:        "08fba35e0667e536c1b379fd41f95420303d6b1cd153c3f4ec8548e630027243"
    sha256 cellar: :any_skip_relocation, catalina:       "8e9189b6a62a93b612da20b262162dfb00a990f6d0b544bf961de7a21256231f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "564852f5bf4cdeefa50fc4f284efba19f5ce709c61703f4d92e875b4b447e000"
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
