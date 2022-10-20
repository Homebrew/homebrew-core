class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20221015.tar.gz"
  sha256 "5163d439473252cdbfb870d8ebb322951dc047f3bad7ba93096ce1a953258e3a"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7c4cfcdfc94b0ccb3fe16204c9c51d762ca319a7c2d6bd65656dc8b0b684602"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "091373f0694763aedf72ffa064f6e5f7cd13650ba34be67a96d9bf5552ff8abf"
    sha256 cellar: :any_skip_relocation, monterey:       "862d958189ff90136a652e6d7b8ce148a4518d7f94095f6efa6c886806e6fb0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0b8d67ab172f479e4296d57a1a93fd415f361c4dc000e96e228a392cd901012"
    sha256 cellar: :any_skip_relocation, catalina:       "7c99ca99a99f041082bdd47bff0a0fb6b43e1b1f8cd9de08f12213ae8cd61983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00dfdd55a67ee8b09bafc947f4d2298b43bbc787bc365ea1fa5f766de7981d14"
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
