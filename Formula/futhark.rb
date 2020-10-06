class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.17.3.tar.gz"
  sha256 "32911a3f7c5e7e83d02007ba53c32f6e5a31957f8f5264c3cb588c0217a868d2"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18a4640fa0de30f699de9387ee00a9cad59adca64439d3c3ac35e1cf90a74d50" => :catalina
    sha256 "1473285d70fb47b27cbc42d47c4a03c9a8dd97a7fd2e50acba22316e6eb47c2f" => :mojave
    sha256 "9b41bb30531c7fa48d97be3f5216af8e6ed12d2299c665b6fc220f81e188557a" => :high_sierra
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
