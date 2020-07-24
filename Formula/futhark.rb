class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.16.2.tar.gz"
  sha256 "04382ba345b530960312977027e0acac36ec84bfb7fd67830ab372ff696b2218"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfcb4213a0a1ad66190471a090492352de2a083b99535243b6113e680ec5abf4" => :catalina
    sha256 "9773f89549451d4b281aa6304a84517d743fbcccf31d3177fb9e5cb5e0e0e274" => :mojave
    sha256 "8fc9b0b1304422732c635a002fafd6f494591b23d888a13e04e4a8074b2034aa" => :high_sierra
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
