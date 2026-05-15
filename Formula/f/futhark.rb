class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "8a6fc24a1ff9b7ec89da8e1cfe0ff4f76889e41906bb413d14633abd920205b5"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a986156c38d3796d7263491ea2beb75d631b7cd2192fa9938f3c56ad58d4f60a"
    sha256 cellar: :any,                 arm64_sequoia: "98d8a3c40c8d3af8585fe47099581f04b67f6dd59e98d147bf34470acc2c3c56"
    sha256 cellar: :any,                 arm64_sonoma:  "13269c9052b806e2be786c307f463add937562311dc4d28967d0492a73464579"
    sha256 cellar: :any,                 sonoma:        "a911bf21349372738c7edbece502f8da5f47681afb91ddb3d30369b71353f3b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "159b41b962fb41b46d654a1688123a7af3a237d3a2dbf232917a1bb5da5eb8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "894f61dd7fdfee95c183f3023c2a8c54949d75922c6be8e13aa480ecde4862c9"
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
