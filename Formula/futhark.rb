require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.7.4.tar.gz"
  sha256 "057e224729e3b70de2cf1275285b55becc496c45de0200667c21f5d91fbf1ecd"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ecbe88c41fe0781cea297d10c0f82387ba23baf67c6db1b1da1e51bfb5d0a8a" => :mojave
    sha256 "4fb416e08c8c725dc187b63ffc8130685ce8bb273ae529a2b8d28c22d7557bc6" => :high_sierra
    sha256 "18583f16a75c272f68414397643b8edf17a9c048225826a00555dd04d9fcef95" => :sierra
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
