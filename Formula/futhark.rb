class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.16.3.tar.gz"
  sha256 "a4b98145699942ac138d9723e832967c1b188611df2d3ff1e9f75ed17a052808"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "19ab139db827ea98e40f3e54ad104e66e2ad66705ba0f5fe25fbc2af5158a415" => :catalina
    sha256 "6791ebc1c3860f1615745e6bb3ed8416781557238e14ea0495bb2e30a4acf194" => :mojave
    sha256 "d509a075e561d263071a8a0fc8e082252b67bc7a6c6705bdbad5d6d5e705b57d" => :high_sierra
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
