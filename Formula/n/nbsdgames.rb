class Nbsdgames < Formula
  desc "Text-based modern games"
  homepage "https://github.com/abakh/nbsdgames"
  url "https://github.com/abakh/nbsdgames/archive/refs/tags/v6.tar.gz"
  sha256 "be261ad068ade07aeb6c75597fd03c6e3dc865fe4d9851fd95059bb6b929dcf4"
  license :public_domain
  head "https://github.com/abakh/nbsdgames.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6febedf483ae10041bba88db08bb12e772b0ee61bcde681136a5562db95541a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e3e350ff39e9990b549ef9e8d0273e8afed66fab59f4500a3165e9fd86738a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a739ad5c30b5ac5ac8364cf9d10c7e247b04008495f4836938e6374633316c83"
    sha256 cellar: :any_skip_relocation, sonoma:        "295a5e24625e23324974fdf6557771593eadcfc45b36a88f8d792f4584ae5f13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9c1272da20701fd0e06a402de7d1a752ba30e7baa5711c78256dd9958df81b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7f6d99ef7d6b6a70da0b8b2c97e4af7e98e4fa928d493b65cfdcb75e5b3e6f9"
  end

  uses_from_macos "ncurses"

  def install
    mkdir bin
    system "make", "install",
           "GAMES_DIR=#{bin}",
           "SCORES_DIR=#{var}/games",
           "LIBS_PKG_CONFIG=-lncurses"

    man6.mkpath
    system "make", "manpages", "MAN_DIR=#{man6}"
  end

  test do
    assert_equal "2 <= size <= 7", shell_output("#{bin}/sudoku -s 1", 1).chomp
  end
end
