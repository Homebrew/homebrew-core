class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.5.tar.gz"
  sha256 "4a7d5f5d0de94e33c622e8383e66272ce26ad1e5719bef72111e615f990182f9"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ea84d5e1b088b1a00fe7f0fe3b8ed68a9f9bba4b124c6cb5825a3d218ac38d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9a8c569e4812856840b5d99776cd9c8232dc5c6b80548b9e0d653e74b9ac5e8"
    sha256 cellar: :any_skip_relocation, monterey:       "a7510d8be10de227b6668fa16a7272a69695035a4ca94862414fe2d783901574"
    sha256 cellar: :any_skip_relocation, big_sur:        "e69f7f307b943a5e1582452979755202812b4df48d380ed86323a41ad29e95d7"
    sha256 cellar: :any_skip_relocation, catalina:       "93e6ac2ffd3a2f946825ed9f5026e7be63f69abd886dbe1fbceb8cbb717b6c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e630a51f2793a5d6e9f5bc462479b553f45172db5652659de42635632f8a7cab"
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
