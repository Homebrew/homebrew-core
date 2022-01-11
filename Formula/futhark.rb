class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.3.tar.gz"
  sha256 "2df81fbf19e8d79ef3a64a4729d6db56e4eede8a21bea390ecc7f441676d94fa"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4160c93be0eca2381d9734ba94f9f7d3cb8c069837953fb2ddde093fa2d3724"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d23b0f34a4abc3c53398cbb2dbac993d2721479e0c2534103af43bee257533d"
    sha256 cellar: :any_skip_relocation, monterey:       "e509106ec34af53530467b6fde8d764305ee7422f7af59b6bbde2ff0f585fe95"
    sha256 cellar: :any_skip_relocation, big_sur:        "07484274f50eda6c07f3e9d2d777ad5f8e52f6e95039f037d82d7f9e57539337"
    sha256 cellar: :any_skip_relocation, catalina:       "dd5289b669cf8f33393c63f8787602c13cc2d509c6bf6738bcc5b0b7f68d2546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ba3bd09504762f1c8f36178cf43ba223250f5c75f5aabf402f33cf05e02b74e"
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
