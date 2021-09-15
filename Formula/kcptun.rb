class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/v20210624.tar.gz"
  sha256 "3f39eb2e6ee597751888b710afc83147b429c232591e91bc97565b32895f33a8"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0cbeb08ced20b11a0f40715c298145f09cb15a1df96193146495af783cc3c2e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "fceb1bc66a46428a08d59ceda920961969ab358b2e938e43140882c8d9bacbb6"
    sha256 cellar: :any_skip_relocation, catalina:      "958b2f9440b0c9c760b766c7a5b8f523e5f3f182866cbf46abb1912e22947b6a"
    sha256 cellar: :any_skip_relocation, mojave:        "3bbf3c2432c91de79cfae4e846973257d42b18d484244cfc74e454019f2ad264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93ff4307e7a35cc96c2ccb7ca0fb6a057a082be0651193dae0903b5951c578b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=#{version} -s -w",
      "-o", bin/"kcptun_client", "github.com/xtaci/kcptun/client"
    system "go", "build", "-ldflags", "-X main.VERSION=#{version} -s -w",
      "-o", bin/"kcptun_server", "github.com/xtaci/kcptun/server"

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
