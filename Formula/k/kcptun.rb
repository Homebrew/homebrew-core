class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20250427.tar.gz"
  sha256 "345f3df927d9496e1266699e4ab8bea1b559b3874ebea1e240b4cfd3578d2561"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "919ab411c452e95d7038a9b85fc8543e4371c6ba4302702c8411efd01b4b8ba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "919ab411c452e95d7038a9b85fc8543e4371c6ba4302702c8411efd01b4b8ba0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "919ab411c452e95d7038a9b85fc8543e4371c6ba4302702c8411efd01b4b8ba0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6c2f08ebfb334fcd1574b9cf4a0bf006faabb2b62cb06e2fdb05b33adb892d0"
    sha256 cellar: :any_skip_relocation, ventura:       "a6c2f08ebfb334fcd1574b9cf4a0bf006faabb2b62cb06e2fdb05b33adb892d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afb4443a3e692c4426a07556a051c32473cf3d539624103b7c0acacf1fc87565"
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
