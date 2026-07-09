class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "a9f82dccfdf2cb1a5c4938e743d682ebf3a5bc69e43f28474a8e581caeb53136"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e7931c3599de5ac5934bd591b54cd367f8fa24688ddb371bd1f9c275b29bfd31"
    sha256 cellar: :any, arm64_sequoia: "fdc0c25734b5aeb5b17f49bb818daa30b1e0ef7598e36441fda2742c75c25d88"
    sha256 cellar: :any, arm64_sonoma:  "a811bb4486c2dab472ae753ad75eda5e6bd2a21768c689e43bff9e4d981e59f5"
    sha256 cellar: :any, sonoma:        "0c3ffe05ac2d47848892fce784909916993c446f0d3392c9d34838f74e7766ee"
    sha256 cellar: :any, arm64_linux:   "bb220d552e4a36c515aa0c22beba2770d89ebd6bd8860e8b8ef708c7e4f61575"
    sha256 cellar: :any, x86_64_linux:  "e2e24e6bfae46afdb260edb3b5a0f5ebb875956472c3ef3e1b478bd8fcd5daf5"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
