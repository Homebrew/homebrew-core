class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.19.6.tar.gz"
  sha256 "54f2f80a6f776c0b644a7599d1238b0b2212e387ca5bd67371d154713a203ef9"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "c93bb333ef6cefc2cb4e1b6f6f30efe66deffcfd92a6a36850b12723bac71ac0"
    sha256 cellar: :any_skip_relocation, catalina: "9d09898f11bfb5442103189aad9cabbf31eb783f00b4568779c65b9f94ee0b77"
    sha256 cellar: :any_skip_relocation, mojave:   "bd6b045a300b654525ee6bc51bbc56648b1830134319f5e8a92364ee5e0f6246"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
