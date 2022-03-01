class Bkt < Formula
  desc "Utility for caching the results of shell commands"
  homepage "https://www.bkt.rs"
  url "https://github.com/dimo414/bkt/archive/refs/tags/0.5.2.tar.gz"
  sha256 "e6acab9ae6a617fe471dceed9f69064e1f0cb3a8eb93d82e2087faeab4d48ee8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bf6536dcf87d5ac9df561af8345c29f42ecc3c07bce600e004cb53b466e88d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab98aca491f41507e3c259b447e4327e8c81a99ea041e74ec0d38955c89a6843"
    sha256 cellar: :any_skip_relocation, monterey:       "4309e37d0ff10c1d15902a5b58b879845356893074fc7d926f497fee7e856e8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "715655016adecb3c09a8896d52038655b760deb48ce3a458a075b37ced143ecb"
    sha256 cellar: :any_skip_relocation, catalina:       "5d8b415f7936cff06fead0736a620217e600236b5daaad98f53914bee5de3fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "370375f057907cc856434efa158e10c0725697d1d41b1be1a3106d01d093a8c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt -- date +%s.%N")
  end
end
