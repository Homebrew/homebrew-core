class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.20.1.tar.gz"
  sha256 "507d2a7074c37ab9f6a3369fd5d8558dd38c69ccd8fc355081df4a16a777621f"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4cc231d510711a6c957bc74e0a582b808054f613432186cdde5cbf42d296d625"
    sha256 cellar: :any_skip_relocation, big_sur:       "c0f07aee523d6334d16e25df1373a261aa5a3fc13cee0cc13a5a3cec6f156185"
    sha256 cellar: :any_skip_relocation, catalina:      "5f12a7e6c8618d027d61b3f6f7b5a16a4cb731639bb94e85c35728ba7ed394ed"
    sha256 cellar: :any_skip_relocation, mojave:        "87dc2f27226450daa18d74ffe05f4512165c790c91442d49e4e3f104cd3d61cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a46bc3ecee5e1e9923c474c48c94082159ed9ef4d0b0691171631aa647f82235"
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
