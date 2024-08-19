class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20240807.tar.gz"
  sha256 "d29194ef0a18cc5a997b21687a759d4a684544fb66fbf0a56203db318277edf8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f143aa30f5366e95ada382cc8619816f84ad18fae283a73f70936fba9ea9499"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bea7f4c49bf20c0fd865e8139ab3b152bf78cdfcc3050dc8e3c537871c32726"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd040f28775de0778a81d54f0327bb22951b4f45f93428a7e9e63a9b6eab27fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3faba0f8b19c0e51d4754a91415b29a47651e2772742dec2ec0fdaf2894dde2"
    sha256 cellar: :any_skip_relocation, ventura:        "0ce827e70154d116fe50696a0fef839c15287b05b3ac01be41e0e34284ccc94a"
    sha256 cellar: :any_skip_relocation, monterey:       "8e10c9008e0d439be052ea4503147d855038dd850e00a3420e8d646343353665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19fd661eeac0305bfbdcc145fbb0977e3382b4929cab68f5258e222d69757dc5"
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
