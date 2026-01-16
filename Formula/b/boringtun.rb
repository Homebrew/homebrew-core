class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/refs/tags/boringtun-0.7.0.tar.gz"
  sha256 "a49f3c230825f44d5c304d95751d7fb4dd2df6ddb9e47535e1b186c8bd8d56ef"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/boringtun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c25b6f0df17bab99cdfceb31f2d5a9cd138bf7964bf645c758d4b5ce0c4e5671"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ed7d7915ab9a8384c3f78e5c2ba051d6cebfa54a1ee5279f79e6c98d650b47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e504446eed22fda2b5c33de673790e413af99d5d319922fdf8b6205360c2f571"
    sha256 cellar: :any_skip_relocation, sonoma:        "3093bdb97aaac295e60d427c12f09adaa21f392eedecb51fefe617d2210ac48c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "576770d4e4f0ab75c50ade48145b27fa9f30ac03e5a24f72b374c7921a8d95d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed03ae2827ea946af365aa93bef4ce8d020ad2603becd561cae40f0e97964d66"
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
    system bin/"boringtun-cli", "--help"
    assert_match "boringtun #{version}", shell_output("#{bin}/boringtun-cli -V")

    output = shell_output("#{bin}/boringtun-cli utun --foreground 2>&1", 1)
    # requires `sudo` to start
    assert_match "Failed to initialize tunnel", output
  end
end
