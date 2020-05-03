require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.15.6.tar.gz"
  sha256 "fa332b217148ca5d8031265fdb427e04c11a847053200ad91dea1cefab4ba624"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "241d75dd1a382664aecb31e0430514264802e2b113e4a0f5c2f8a9870f78deaf" => :catalina
    sha256 "f0cd37ab8deab5538031783cbc2abc069fd9df1f870e0081e47e2492bf706ecb" => :mojave
    sha256 "33c99e6ec9b7cb0fa66408ea8f51c7f781626162b92830b7c4c0f243acb2480b" => :high_sierra
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
