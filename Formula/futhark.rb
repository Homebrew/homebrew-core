class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.24.3.tar.gz"
  sha256 "c4413cfaa175a6e1a0402731ac4e556c9c4db5e9d17ed0f45129bf89903cc9a5"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "746ba94cf45c802bec788d6f14fd8bb83ea979a3799171417ca4c6dbe3b411ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff6ec4feeef10c3b9d91653a7cea4cc329bff98075ed038601461e8629274c1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c7580e6e94b436ea2d9471454d56a868e458937dd13d8a9f014796f61086933"
    sha256 cellar: :any_skip_relocation, ventura:        "6043ae0f499ce05e82725743a4b9608612242eef0873051828905f622db3c9ba"
    sha256 cellar: :any_skip_relocation, monterey:       "bea1415965f5687506bd25fed706cc520ece70a324a0c8f70aa59f8f3db248aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea85c694e2b31be1d7d5a62c311ce3c8b0326e4c1832fa79703670bc4741e64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f038c727889de95ebe7b2bd1841c3afbadeb3fdb6b85220d0eed998175617f76"
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
