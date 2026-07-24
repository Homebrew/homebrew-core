class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "733c7b756591991e6b4ed43a16cb82943888242f2627af910177fe22486fac0b"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6082acb1e2667f56392f26711cf9abebbca23e0e06a41325f134b31f80d88b8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4ae73e9c371edb4ad159044923dd8b7ba47e933a212d70b9ff37570e280b9ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf723b1d43cbdb5cfc22e00541009589a74daa7e97322cd8cea13abe4622b79"
    sha256 cellar: :any_skip_relocation, sonoma:        "e98d04a235db697a55e34220ff6079c1a33b9989de0842a640a8694ff63ff7c3"
    sha256 cellar: :any,                 arm64_linux:   "47e4521b950ab4283f0e211b8ddbaa8778281244b0612ac63c771883f297ca84"
    sha256 cellar: :any,                 x86_64_linux:  "7cf5020f196f46bdf9c87f22cdcfe46d3dcf17ac3ab1bde33a8cf417c81dab56"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
    assert_match "ok", output.downcase
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
