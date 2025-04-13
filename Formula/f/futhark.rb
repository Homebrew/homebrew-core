class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.29.tar.gz"
  sha256 "9a7baeb70dde083a3e1431da920a820d1afdb0363b21a6402f7adb3732b1dbd8"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e067a4669708a3684c6e3f4d1e0092796b2bfe3f583cc678154c9ad0005ed208"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1822ddfbe05fd135e933ef6286a7f79627cf73e2b1332c9e9c67c31922dffa2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acaaa46da22d3b3706133b43afa9d4d3f4849a4493fa2c3bb9dafcd7fda6b164"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa1316c2fdde22761cc79e018f10acada7f76e000e16b599de9c50282a45d7b0"
    sha256 cellar: :any_skip_relocation, ventura:       "7f3f8383c0b16688cf8a7a801491024267f235d7dbc689ba123ef8598a5fedd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc1b84b83dc2aab93a013baa6d01275765f9673748a87cc5380752311dc25ce1"
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
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
