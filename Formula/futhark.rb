class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.19.6.tar.gz"
  sha256 "54f2f80a6f776c0b644a7599d1238b0b2212e387ca5bd67371d154713a203ef9"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b07cce8318db4102eac3a4f59cb3beb34724c31079798f46cc92f2c59f46c7a9"
    sha256 cellar: :any_skip_relocation, catalina: "fce4f4bc59c4228914bb8d9e7e400e5515aa4c19df1231b3f21fdb326094736e"
    sha256 cellar: :any_skip_relocation, mojave:   "17d63014d7da322f475ea1fa5644813b7c07af99674459296446c4f01df9bba9"
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
