class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20230214.tar.gz"
  sha256 "3ab7b2cc3cdf1705faa76d474419a2d9e8868c8b46a24c93a218bd6a5acb2de3"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a3c69dd05d16457e7bf96a05281ceb6417c1298a6f5c54f068891501c24b0be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60f619bed1bd429479a2c87a48a9e72bb4420456a79951867af24faafcd235b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f41225ca816de2f14237bef82956a02edc6f3a2d3e74d367595e397afbbb426c"
    sha256 cellar: :any_skip_relocation, ventura:        "53366ee01bde863ed8d496eed23c68ef2f717f39e2a3dcca82c20bd4b86dad3a"
    sha256 cellar: :any_skip_relocation, monterey:       "16025109d56966ac85682d17eee1f4fa2a0cb450b9f25dfe42cc2461b9a6cdb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4362e99e6090fd07a722386abae31f4bcc0a9ca397c7ce8d3e9dbbb0b05b9f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b16fb8f3abab1d47e81fb3144794a7e06f3e59c76ac7d939a03b8475355c6ac"
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
