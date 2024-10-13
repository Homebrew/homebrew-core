class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20240919.tar.gz"
  sha256 "80c2dfe277196e5aac19272f30d83b588f57f6e180b22c5865b7864080cfed09"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad2c540a88ddc13b9e4dbdf38f7014b9895d1b05e3dca14dfdbefaf29323bd0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad2c540a88ddc13b9e4dbdf38f7014b9895d1b05e3dca14dfdbefaf29323bd0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad2c540a88ddc13b9e4dbdf38f7014b9895d1b05e3dca14dfdbefaf29323bd0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7108d6cededa38b57e469b2d918909377bf88169bf8b2a489ed1a0b1f3fc29c8"
    sha256 cellar: :any_skip_relocation, ventura:       "7108d6cededa38b57e469b2d918909377bf88169bf8b2a489ed1a0b1f3fc29c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74c05db9c0892742052eb9fe44520b3b7ce3a99792041d45cb65bf730e66c174"
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
