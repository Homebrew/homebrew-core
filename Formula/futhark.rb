require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.14.1.tar.gz"
  sha256 "375ec3e8cc7bb54cfb042684353446c1df792c3d409cd0082256e6446d696235"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1038fcde32b0aa624f9df67d29091762cd3f26055738fa457d9363e18dd36490" => :catalina
    sha256 "bbfaa41253c3e5a32e49eddedaf0e4692910f4fe2e1d7fe4818039256d961723" => :mojave
    sha256 "82127e3488b7ef46d6f64afe20e3bcd4fd444d35058e92c833a81748c912d2a5" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "hpack"

    install_cabal_package :using => ["alex", "happy"]

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
