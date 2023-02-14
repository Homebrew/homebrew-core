class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20230214.tar.gz"
  sha256 "3ab7b2cc3cdf1705faa76d474419a2d9e8868c8b46a24c93a218bd6a5acb2de3"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a219302acb2f0cd033fff23c90ef116245294be13e4c48a611466a0b3c605690"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f23dd469487accaad22b99564c95fa7624c3ee7ebdeecd7da85c236a64c22d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40a1928f56a189b808df9efe51b8acf732acbfe4d80c87031dac61f76919c0f7"
    sha256 cellar: :any_skip_relocation, ventura:        "c79d2864afe969f9ee95e7d26a4f84d4db28d7b0f01bd370ccb1d9e7b371b31c"
    sha256 cellar: :any_skip_relocation, monterey:       "8015b298f5ccf782e13e3084b44a015b470936d1bd5f5b2f6b898d04dfa39e2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "07e93b7ca941ab2f681ed4f07a9e9335fb8106d9e945e62c70930e555b18c5f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cad997fbb8e8f897f751c4c331e889ff2c8b48c09415963bb78d22dc54720d4"
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
