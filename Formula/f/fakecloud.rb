class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "71939cfe33fecf3b617b4d10650cfcfd0266cf8f64712f54357e06e9aa0d52af"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d701ed64faec106642500b47053fb5cfd908fd77b0d2abae688d1dac4417bbb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0659a91320e1534cf433c61acda311fbf5fecb802c0721a52ee7f86524e6c499"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ce0df7e4999435b98f182a0f9c0954ff17024446be49f971743753846a4f655"
    sha256 cellar: :any,                 arm64_linux:       "8ffd2921bcb8c07a765f6bfb42127627033100ca863626cffdf3367c0745885c"
    sha256 cellar: :any,                 x86_64_linux:      "68b30057b92c49cd7435a7c1c03ffc35b825d44ee445d1886408ff1f1a27b40f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  # Test binds and queries a local fakecloud server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
