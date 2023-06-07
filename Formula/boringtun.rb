class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/refs/tags/boringtun-0.5.2.tar.gz"
  sha256 "660f69e20b1980b8e75dc0373dfe137f58fb02b105d3b9d03f35e1ce299d61b3"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/boringtun.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "771e9f8fd6958064233b4740b6802ec798ec64462c02a3a85c85c27c76138192"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7918d4b24e6a15ae72e03d5ea2aa83c0feb7dc6b5be96b687f87352581327a6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4be1130077bf81005fdfcc1fb871b9107251aa945eea633d017f673773ce730b"
    sha256 cellar: :any_skip_relocation, ventura:        "ef525de5f1b5fe80e35994fcaf91e365b19aca09592fcc3fe3de17d6b363288c"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a19a3612bf4f8500cb116efb36e7455ebdf2ee3baa3786573a4570cd0abc09"
    sha256 cellar: :any_skip_relocation, big_sur:        "13109557e5560e9dc8f5206fc9475f3738ec2bd802a5dba5f96d2df7551105fc"
    sha256 cellar: :any_skip_relocation, catalina:       "c1a5968594032037de5a17596cbb487b9ad90a010adb3b7a0c41792241fafd7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c30345c5bcef09072ad4143c2b2136ce6c6b6ffd56a583db5f368b037f0b61fc"
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
