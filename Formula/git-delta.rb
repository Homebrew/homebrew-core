class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.4.4.tar.gz"
  sha256 "4068cb88a4110bbef24b8148e3ae283ff007f4f6aa4780789cda7a412928daa0"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ca2f88662822e52195b10e52f16f0261a3faebddf4ec30496997fab3ebc699c" => :big_sur
    sha256 "3561fccb1ff28c7021d5cc5ed549f3be47dfd4127787510aac38192670077f17" => :catalina
    sha256 "6ece760a0d39fbee0b2d40237c3a0e81c1d67df655502072dc06077676ac43ea" => :mojave
    sha256 "a5767a8e9621884bb26cfb4205ffb9b2e2c0ff53536d79981ee2e22ff823a474" => :high_sierra
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
