class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.22.3.tar.gz"
  sha256 "95fe8c9d9923f9887457c83e4ccf9bf9f37f86b23124894afc7691939ce94d76"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7357b7e2697a0d5aa3ef27cd7dd82ea72af66f6f08839ef3c0e4b4c0ab81bb30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f364f693aefb17847d2757340b806c4bf4e8d63ec42601b5894259e24ff58d64"
    sha256 cellar: :any_skip_relocation, monterey:       "ce482f15d4095f8fd71f3fad34f3853779564282e7af1f8a4a96b978fdd929b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fa77c56afaf6bc42a2ea3c13b249bc5a16d13c2bbdaf1a512cc5870e346f563"
    sha256 cellar: :any_skip_relocation, catalina:       "d31524dfb24aa41da4156367448fde0782d64ef6dcdc9e9d619625c1d47981af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2216c86f4d3644ddcd3adb010fc24ffc55bf63c4402088e3f3cd30280b1531f"
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
