class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20231012.tar.gz"
  sha256 "130a0936c3b1e226aa062d957bc420d7d1b90c7a4c71ac1a314c0074cc2fbdc6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17e64597524641de1b01fea4ed7017329a06e5b037e80b4f137c27141ac9c4f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7c9d995b7dbf68deb048c9a4b17861ee4f67aa1766d32a02f4df3409af7ac85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b2134ae76d0effb787f23d9b0853a41d6571c519941d371e17447c452123d6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b42dcdfceffa376f16e8c4bb37e4202d759cd914786fc1ba091d2b09dac62bf1"
    sha256 cellar: :any_skip_relocation, ventura:        "c3e15f8d48f7b1347314d7e871168f47362bdbc39ac8b4bb0a87437863cb3e2a"
    sha256 cellar: :any_skip_relocation, monterey:       "981bac847161cb5e74769b5107a9ad8a143c02880a1fe3843a8b64d3ac3168dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68865618a0985436d15ac0dbf8fa8e21bd846cca7acb47a6fb41d4355bcc8db5"
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
