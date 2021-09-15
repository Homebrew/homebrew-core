class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.20.2.tar.gz"
  sha256 "27674fd03ee8dae147b1aa8d5c1d689aac54707f8c93feb6d930506138af61c4"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c74f0f412225a00d1fd221d7cdf72cdf387211baeafe3ca609847313053c95ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "3489699b76cdc904ae47a7a3c6cd3b0499e2a92216061ebd506172311a3e58fd"
    sha256 cellar: :any_skip_relocation, catalina:      "4dd9b3336521d670373e2b2537745d45f2fddf376635dfc1eeba72fb1d568437"
    sha256 cellar: :any_skip_relocation, mojave:        "129c0a12c61a29603c2e3ffa709eed09baaff33ae071ad54c2fdd7f79cc995fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8664cd25dbea1fee627c5496bfe1a4171dd348b4ac6b4ba585cc22d4bbdb67b"
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
