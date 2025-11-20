class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20251118.tar.gz"
  sha256 "e40bd29ef439e66e0722768d37361c9083aeed3bb81324677b536bf0fc1ce6b8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "616c58f2545be78ac9b58ca214deca9aa84ee66dfada94849c55445c6b84f6f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616c58f2545be78ac9b58ca214deca9aa84ee66dfada94849c55445c6b84f6f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "616c58f2545be78ac9b58ca214deca9aa84ee66dfada94849c55445c6b84f6f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d6f83a8abd509e068f08eda2236fb4b8e654441ac2bab0aece2b7631300e06c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "422e570b5033ee9d638ee3ec86686df2f4b2b6ac22404452234c47ea341be5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9863b8fe60c0f60478e4784433deaa5789fb000ac37edd111740bfc71c716f93"
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
