class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.17.2.tar.gz"
  sha256 "f07aa87d982b58af75083c08a6ef9f895ceded853d6e6e9f6d468991470cec39"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "192095777a9a4f3d99d1de41e49a37ed857ae6c445fc05080828b946c83bd6ca" => :catalina
    sha256 "9ed19f15389703c67f6acb6ca3e52f946376ac6c6a2763d8d78fafa6fec32a95" => :mojave
    sha256 "6fa78da5955343c085f047f729a332fdeb76af086e66302f59f913fdc3d8795a" => :high_sierra
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
