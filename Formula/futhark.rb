require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.15.8.tar.gz"
  sha256 "f18e7f2ee6f71368f3faba2b4c82f83b922a4c37d43e28889abd4d58d582a526"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1c991d2f1a0a459df495c22db4ff0589188698ea6ac395b0dc27e70b1c00a7f" => :catalina
    sha256 "54459bd8d974e77e1f81ee215a0b7f194592127cf25092c1c5185a05309427d2" => :mojave
    sha256 "891d31e967afed439b26105cee728b90139c6280da9f71c8689b49232f61f26d" => :high_sierra
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
