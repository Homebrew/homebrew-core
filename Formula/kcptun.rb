class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20221008.tar.gz"
  sha256 "a52dcbe336a27c256a4f25ceed5961754ea584a899b92757c54e7bac25d5efae"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a269ec094e338840116353641cee0e37c93ec85b40da65135247a5027d01107"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b82b98e079b22abdc95a39e91cc2787dbea777f0a36100e5e857f5744a6b67b"
    sha256 cellar: :any_skip_relocation, monterey:       "063b0a831a47d7533c7a95871d1f781e729c2cd265dafe165f433885792b5b91"
    sha256 cellar: :any_skip_relocation, big_sur:        "35d3cd1de73a1bfd7289601b12cf06accdc49ec7cd63411a12a07fb2cc6d4e86"
    sha256 cellar: :any_skip_relocation, catalina:       "0dd883fec021d754ec826779102e8117ecf9410cbb9c0bc0c3ea32e09c348030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60646454dc1e3e4e52dbceebe760e730597715742bfc6d9858d9465e3a3e7756"
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
