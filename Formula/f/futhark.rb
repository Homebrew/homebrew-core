class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "13b75dc398f5c610a528c0d4352fa6e8c309d69d940e9f416c15054c77ba12ee"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "58f9701ed8d62fb2970d2533369688c8e87150b6a379b597e82ae8f95172f120"
    sha256 cellar: :any, arm64_tahoe:       "a602f3e7a4a65317008c3cc27ef5b239312335d5f5c1afd8def55878f35fe428"
    sha256 cellar: :any, arm64_sequoia:     "f9421f3f9f1ce03afca11364da18a462111fc53134187ff6ea9a71db9c82dbe6"
    sha256 cellar: :any, arm64_linux:       "5507f2b94d90cda6fee3eb8bde736a91e182235e1c5f86dad3ba7ca6d6a246fe"
    sha256 cellar: :any, x86_64_linux:      "d0cff3440ae0f50dd42af1a942ec73b9c9ed497d92b94a8fb10432bffd52ac00"
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
