class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.18.5.tar.gz"
  sha256 "62e40af86afb357cf443861ae4f10662effff42f2981d103943ea20aefc6d076"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8a6c71ff19ad47d8568ff2cefbc6eb8707ed2409422dd51340a745302c865fcb" => :big_sur
    sha256 "bef296e915d5459daa640db1dd16662b8e1fbbb84aa6417cf19c9c2235a03851" => :catalina
    sha256 "f3feffbe5f11434a705cf132c25e98cef89db5914a6b64a165b0ef5f5da4803e" => :mojave
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
