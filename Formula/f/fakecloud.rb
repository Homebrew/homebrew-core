class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "27bdb740d82caf8d266825176e3150ef81ddb307cf219f6f91abeefaa0b5b1ce"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2eabc239d63398e2b8c89b08d5b934c33b1f297ed61b54c85d7f011622902fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1439ee63d5284ea3076b1d124306591a519a6d301491940d64ce98af98c6b98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29b3af4a87fca9a6ade4c0ae18c9e18835afa18fac61cdeece275651c7bbc64c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d9195908309ce6e6e8d39610d6e03efc40a1677d7dcf27d6cb0b0148dba1047"
    sha256 cellar: :any,                 arm64_linux:   "2c2315ce25cff2cb4067de3599d7add123f2bcb65030ad10cfd7f7851a412f65"
    sha256 cellar: :any,                 x86_64_linux:  "f2902c9c54aed24c1917694006ff27ac93b8f17e9f8e0f4c7735c0cfa2f22dd5"
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
