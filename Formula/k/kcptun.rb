class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20241227.tar.gz"
  sha256 "744688140df5f72bf9f5cc26ed61ce6a2a2090c0a5d5bf54e3b67b6c933a6c51"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git", branch: "master"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "866882494618aef86ed0b3751654a8c13fec2e91194fb3b2b061bf7186e4078c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "866882494618aef86ed0b3751654a8c13fec2e91194fb3b2b061bf7186e4078c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "866882494618aef86ed0b3751654a8c13fec2e91194fb3b2b061bf7186e4078c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd9c28659adb72d7e6dd8ca2dc34dfd380d1e383c05428ededf4b9c62cef4cb2"
    sha256 cellar: :any_skip_relocation, ventura:       "cd9c28659adb72d7e6dd8ca2dc34dfd380d1e383c05428ededf4b9c62cef4cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7558c6fa73df28999fe29dd176902da77d9225969f34d476cda9b5141e648b87"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kcptun_client"), "./client"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kcptun_server"), "./server"

    etc.install "dist/local.json.example" => "kcptun_client.json"
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
    sleep 5
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
