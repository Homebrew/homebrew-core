class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.16.3.tar.gz"
  sha256 "a4b98145699942ac138d9723e832967c1b188611df2d3ff1e9f75ed17a052808"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1c504ad71048442e75a65f77eb468b3e1435ff338ba684d2a1d7901b9a87df9b" => :catalina
    sha256 "9d31eb9c3146794fe12d6b7dfe906758f5d04f3d5fde852e2421e56e09ae9c38" => :mojave
    sha256 "500a598d2ddac21cbc64063e25c320b23825d46006931bc3cce602424bf7b56e" => :high_sierra
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
