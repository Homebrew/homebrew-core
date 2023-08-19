class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20230811.tar.gz"
  sha256 "dd88c7ddb85cc74ff22940ba2dc22f65d3b6737153b225d611abb801a0694c4d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d46b30f802914474dea2a4ac7bcd3b8a06ab12ae0030cb4285a00aac22eec6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be93b3e3e26e07f9bba245efdf55a4f970367f0655e22a40d7cdaa19538c2012"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "102cee7da5bb4bae1abe8082f965377b7dc7cb8b9a1c8a85f90df49d8a2eb43e"
    sha256 cellar: :any_skip_relocation, ventura:        "500274c46344a4cff3c99d68647e7fea74444c477abfd0d65ddf6c135077428f"
    sha256 cellar: :any_skip_relocation, monterey:       "1a06832a6c15e48ec155a8402ca1aa7c77086c286260bf89857be28d3a28ae9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "616aa1790b2d5737d4f81653029c8287096ec3496bec16e347512f1ed43f6953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87d1a53affe70f65b659dbb05504899e447dd5317a8d54a8f3b619371b40872b"
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
