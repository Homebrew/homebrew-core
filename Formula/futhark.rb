class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.18.4.tar.gz"
  sha256 "262dd8024c58ebb05964010227bc76907c873f261ab3348ffeab5fa5b1def022"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "239f061d4df506b850592ada004cb054d3e3a14d3ea8b29417b8226b3e0bd5c1" => :big_sur
    sha256 "2962b067a2dc35d1eb807e75f625e706be5159c5e16db3f89a6ba2b924500909" => :catalina
    sha256 "8eeac644f1983cecc78ef0ec5afe2b4bbddd929520121a94de46dd420865a8d6" => :mojave
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
