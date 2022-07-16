class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/refs/tags/boringtun-0.5.1.tar.gz"
  sha256 "6de89f0750e401770326639ac1506fad457d26acdfe8d23a5dff6184684e4cc9"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/boringtun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f85424ef755e4d35c7ad267c704475b1d6579a3c83efdad6c0dcc37f294f328f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e11b90142e4659eaa89a21fed8af3f674812bbbc8ec648bda18341468b11bdd3"
    sha256 cellar: :any_skip_relocation, monterey:       "f9698cd5d69eb139caf2e8c7001c31529c787ce8f1d618f9dc1a9c18359acdd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "118cb4e7bce35959d9afcfacd02a3c1204bd5ddeb8d73ac007cec8b0ef187ce0"
    sha256 cellar: :any_skip_relocation, catalina:       "692655e8e0b63fd7d0b832c6dffda08fede456e60d81e6db1159d2d11a1bcaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9c3c8a3f3472c02bd03a35e83cdb114573a294d4e0608c36075836dbd292099"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "boringtun-cli")
  end

  def caveats
    <<~EOS
      boringtun-cli requires root privileges so you will need to run `sudo boringtun-cli utun`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    system "#{bin}/boringtun-cli", "--help"
    assert_match "boringtun #{version}", shell_output("#{bin}/boringtun-cli -V").chomp

    output = shell_output("#{bin}/boringtun-cli utun --log #{testpath}/boringtun.log 2>&1", 1)
    assert_predicate testpath/"boringtun.log", :exist?
    # requires `sudo` to start
    assert_match "BoringTun failed to start", output
  end
end
