require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.5.2.tar.gz"
  sha256 "c77dd18b910b1d7c934d2941db6b22591c53a2bc0c90addfa6f14df6747e080e"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd818e83ae8576266a6895c7214af5cee581b0e6d8a370c4faeb04c74f475388" => :high_sierra
    sha256 "a6480d5a5fba3f6ec8a58ccba3154c3c995adbe1335ceca92967f0d5a90f0a90" => :sierra
    sha256 "941ec7fc66507cff5200749d056634ab527c4a7297297737b26004265ee50f34" => :el_capitan
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
