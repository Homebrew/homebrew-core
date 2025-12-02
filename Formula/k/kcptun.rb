class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20251124.tar.gz"
  sha256 "40cb63b8b026dfadb954c352c7a3633507fc49a0a1f12b47e6c69000f4eb5ab0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca817df14ea87224b8017149fddfbe7e96b3df72194a47457ce0b0ea5cdf9713"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca817df14ea87224b8017149fddfbe7e96b3df72194a47457ce0b0ea5cdf9713"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca817df14ea87224b8017149fddfbe7e96b3df72194a47457ce0b0ea5cdf9713"
    sha256 cellar: :any_skip_relocation, sonoma:        "0921465056c600b8123b6f6df31ed82538cb3a8cdc944712bf6b28c1f46f453a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c532d456cd152ddb5263cb3dbccd591afe99ed69d93bd789fdfebf87d3773da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca2347b001640e1fff12cb2f936f7f78037e3d09a53b476e3fcad1c81d5378b6"
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
