require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.6.1.tar.gz"
  sha256 "b8d05780de3b7d8f00461def6944ce2b00b2e3437bb74f50d2df64ce3ad3cb82"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a64deeeafd981d802f0d8efa597cdebaeda21598e09751e2ca42c6c8ec2800a6" => :high_sierra
    sha256 "5aa56c5ef27eeb441087f94071c9202e3e776b735fa62f3fa0ddd7fd77950a77" => :sierra
    sha256 "e50c536cdd798abd63a7151d578a25717bba3a35241de726b10d1613ac55cef1" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  def install
    cabal_sandbox do
      cabal_install "hpack"
      system "./.cabal-sandbox/bin/hpack"

      install_cabal_package :using => ["alex", "happy"]
    end

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark-c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
