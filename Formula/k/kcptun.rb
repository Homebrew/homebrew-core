class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20240107.tar.gz"
  sha256 "4a21033a3558fc9089303505457eead5366af961a7cd56f1856e54ef4d65a1e7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d33256da2bdc2a4505c1909584003f2ac7f1f193e5370e1e042b23520ffd45bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a57078bdc0f97927092a5729ec155f7c645bffccbb6189df7e601d65f76e229"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2be52c70cf71d7fe2a2e974f3ca7c887ea38cd08dcad461a1ef69699a525fc3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "adacb611f27bacdfbf3790367b38bb9fcf4dc971295377072c37c3403878e549"
    sha256 cellar: :any_skip_relocation, ventura:        "d3565d2b847280691a59882dc997b82263420e185929843de296c1b16b07a1ba"
    sha256 cellar: :any_skip_relocation, monterey:       "fc13eedc2788cb7045adce27840dbd74a790b9b6d5d31f34fd85c144a3af648c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "694a9cc3d41f499215f8ce18c6e49f45b75b9dbc32ba1099b297534b4a2ca8ae"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kcptun_client"), "./client"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kcptun_server"), "./server"

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
