class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20260101.tar.gz"
  sha256 "814dcd0b1af47b8230b28139fda2187b3b1c2bf4c04b31648d72bc32daca299d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "966cf0596429206627bddde19064d5056c205f7bbaa2f4a8359d7b3e045ee433"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "966cf0596429206627bddde19064d5056c205f7bbaa2f4a8359d7b3e045ee433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "966cf0596429206627bddde19064d5056c205f7bbaa2f4a8359d7b3e045ee433"
    sha256 cellar: :any_skip_relocation, sonoma:        "da4d188c1e30dbe1885719381bbc3e5c39304f22d714efec18cb2de64c2c5123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48bd3cba76710b64c3ec47769984b02cc006e79c344af099ce0cfd6233fc315e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c71cd11997ea6c9d0454a6ee452c619b178dfa34918e8f9c909998a138ab423"
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
