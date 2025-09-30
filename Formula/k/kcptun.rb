class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20250730.tar.gz"
  sha256 "5d418e87ff41be3cc19cac4514dda8697af8de6b68089eb7e46817a0963619b7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2019b7ad1bb658ba9817df5f5e0080e28edb086d3f8fe9c8427b5fa93488cc6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc7c784444bff8abe83d771a21dde16578a772ca63ce6109e00a8d7ada826d73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7c784444bff8abe83d771a21dde16578a772ca63ce6109e00a8d7ada826d73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc7c784444bff8abe83d771a21dde16578a772ca63ce6109e00a8d7ada826d73"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd3036565c3c658303b0cc8ff1088179ece5b1473501642ecb6e7702f3fdb39a"
    sha256 cellar: :any_skip_relocation, ventura:       "cd3036565c3c658303b0cc8ff1088179ece5b1473501642ecb6e7702f3fdb39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9208ce6607fbff620e403c5f143e4c67eede8b7ec75ed4a0e36961837e3b9f4"
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
