class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.12.tar.gz"
  sha256 "b5610709339885954fd8bb9f67bfc69fbebead9a573380bdabce7c425b23697c"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd928dbbda7c703e770b62f08b517dfd59cc8445ed454af17dd86324d2365979"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c22427f65be038a3b3ce77cb8ba538f3af67f7170970af4a3080f1fa136e8ee7"
    sha256 cellar: :any_skip_relocation, monterey:       "f187d0c794da205a0eda703bc07916534c3312cdf4420e03fcf5ca5cffd63fc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a0f4ce3a8087a6aaf8f20cdfac839eee0e3cbd1fa83d882d1c7882d185743e9"
    sha256 cellar: :any_skip_relocation, catalina:       "1ebc48832ab744f89bb375c6a95dd59c62a555ce2b8be8597e1f5ed6f02f763d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e86a5dafe8ea950909a6fe7e9e87d1e487871f71b59515b25bbe0d140f2035"
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
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
