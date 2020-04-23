require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.15.5.tar.gz"
  sha256 "79209fe5cd51316d86b83dc5928de24ec6fdb35516c2511aa261ab80307ff405"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8310a13577dd9391529789e3f6aa870d56b752b2701ac1811ed06cd9111fe4f5" => :catalina
    sha256 "ba2bf286e27a90aa52f5b86ca0be772176abf3c8767f3b1f46498e54fdd8431e" => :mojave
    sha256 "54c65e71fbb5ab67d406c417f77d70853b5bd12a740eff0687a8837581b1cf71" => :high_sierra
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
