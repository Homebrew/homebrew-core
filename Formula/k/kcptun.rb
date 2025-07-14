class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20250612.tar.gz"
  sha256 "4c4a3e6af72058174c5fe47c92cabea5b326a7cf1402248d6906d5f08cc6c5b9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29f98174d6cefe4668d07678e18585e76457a04b95696feffe0a0a434aca0945"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f98174d6cefe4668d07678e18585e76457a04b95696feffe0a0a434aca0945"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29f98174d6cefe4668d07678e18585e76457a04b95696feffe0a0a434aca0945"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2aaaec21de763260611171d0e91d0a4bc617682030d8cf5e7eddabb0de22c46"
    sha256 cellar: :any_skip_relocation, ventura:       "c2aaaec21de763260611171d0e91d0a4bc617682030d8cf5e7eddabb0de22c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2489ab8c1e9e85c3e354dc8482ee146ee1a37cfae05f5fdafd895b6eeb0b661a"
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
