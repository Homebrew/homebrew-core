require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.11.2.tar.gz"
  sha256 "a79d39fc0cb4251fadecd8077df4243a03c4c7797304783567137aec21eaec8f"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "609b824972921cdec504d28e97c8a8192cc04bc345d90c103c494ec18d5307b3" => :mojave
    sha256 "4a42667a437bbadaa722fd3964966c82829840ee3a19907f19cde046109628af" => :high_sierra
    sha256 "d5ba49a3a3c378dd4d920ca704da4f74b4b492ece996a2b52f05342b6db66998" => :sierra
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
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
