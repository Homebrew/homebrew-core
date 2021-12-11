class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.20.8.tar.gz"
  sha256 "70b0058f136d2064149dedf8881c0cf65bda1ab1a8b81cb99145635ec4e2c47a"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3746692e2a1bdb6222a290f5db42f50dadd38b3a6e8f2c46938c319f1dcf77d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24d3cea6b0878d73227efb6149d45675225607b339186b8f5527db5b1b32934d"
    sha256 cellar: :any_skip_relocation, monterey:       "d4a66367a06db8d2540bd9b5d30a18bf67055884d121586fa71de66c2d59a332"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0349ee3f62f4823f7e99566466f8a348e4ab3d3ae1e61e25d7407f99654d59c"
    sha256 cellar: :any_skip_relocation, catalina:       "9375b8265cd423f7414ce0a326eca07132936364037d06c40266c29bca694dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e93710146a8c568ff9ca4da5198cb2fb2d108525e02a0741880a98f01d4bc5f5"
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
