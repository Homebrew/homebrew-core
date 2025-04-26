class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.30.tar.gz"
  sha256 "6b164d08f173b5b670f99cac9e7eef5c551652ba0ef86e07dd4d0936add19ad3"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "210c278e518d21f391ad6493f16b478a35b3f2f7b56a6472c15aadb4f3da1bfe"
    sha256 cellar: :any,                 arm64_sonoma:  "257e3e4dfdb9f20731ad4443e6dbe735c793218482be5cb1a55e0f9f31271887"
    sha256 cellar: :any,                 arm64_ventura: "49deb6fe0c2e12b5e4942b4e69356a5ba6ed077e052a904cec0add6f2e7798dd"
    sha256 cellar: :any,                 sonoma:        "1fd9c79620d83a7e068b9e4c9b2133b69c7e92e35a80cdd99d9f4450f8b6f480"
    sha256 cellar: :any,                 ventura:       "0becf6aec8966cea8a3ac227026ccc114963cd64f985a3c9156cda2913c01323"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "293f1e741057ff2ed75ee52c151410223a3795c0b59ebf354d8279b1454ddba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a322fe81e8a3500612323a5b6c56c3634d8367eedfe35fd0d9b99d80a50c058"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
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
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
