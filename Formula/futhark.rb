class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.18.1.tar.gz"
  sha256 "b9d9abf7b5c5204c12d5fbde6b60bcd9a8692f171b8fd70a67213ba5092e5bfa"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f118ffa2a1850d2cc4b913b730d643028b524bf7e0680a142c0150f04da70ba6" => :catalina
    sha256 "26298e76327b8504f57fc2b0762f1b0680519184881678161b299fd904f4b168" => :mojave
    sha256 "9272b36bd8044cb7521c17bc777a50734223a50f5460a33b96fcf997777863d7" => :high_sierra
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
