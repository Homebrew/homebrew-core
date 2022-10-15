class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20221015.tar.gz"
  sha256 "5163d439473252cdbfb870d8ebb322951dc047f3bad7ba93096ce1a953258e3a"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b025effa2e26f0ec9d3e2a9468a9ceb9495bb262170c3146f85209d1d9f7368"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2990c7d7c0fcf20c175c85808c822c1b0bb1e2acf03179a19a4756e0c7bf37d0"
    sha256 cellar: :any_skip_relocation, monterey:       "46d274c92405f9325e0c2820b44f164754909fa373beb84396c04b7b20c25718"
    sha256 cellar: :any_skip_relocation, big_sur:        "16b621c46fdd068a926896e1b3812ae4354fcaf50348c7282be597cc6ed024f1"
    sha256 cellar: :any_skip_relocation, catalina:       "9c86aed87076d40b2d001a819644354735e576146c88cb619e4399cdc7d82b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94a36956ea73751993982b4b9e9259b5764f06b8b58d3e797515153d73188cfc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kcptun_client"), "./client"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kcptun_server"), "./server"

    etc.install "examples/local.json" => "kcptun_client.json"
  end

  service do
    run [opt_bin/"kcptun_client", "-c", etc/"kcptun_client.json"]
    keep_alive true
    log_path var/"log/kcptun.log"
    error_log_path var/"log/kcptun.log"
  end

  test do
    server = fork { exec bin/"kcptun_server", "-t", "1.1.1.1:80" }
    client = fork { exec bin/"kcptun_client", "-r", "127.0.0.1:29900", "-l", ":12948" }
    sleep 1
    begin
      assert_match "cloudflare", shell_output("curl -vI http://127.0.0.1:12948/")
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
