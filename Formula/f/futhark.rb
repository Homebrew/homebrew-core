class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.16.tar.gz"
  sha256 "1192fcf50671bc8ff2f60e754e500fa2b6790a7e38d7eb5fc7db303039524188"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e981fb2ebbe7f7bfcabedbe636d160ff5ca7c736739e44a593b75fafe093cd9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4395a2b5a7ab6cb789431379e60e33b71a8fe69519ac6eed6c2b351c7274c1ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9def2c782e2e816410b2b20ac5415175130b115c83456e97657658be0c58eda4"
    sha256 cellar: :any_skip_relocation, sonoma:         "999badc5af59698fdd5d4fa773cec7c15e8af088164c94527d440e471bdbd724"
    sha256 cellar: :any_skip_relocation, ventura:        "c15dce449b317ea4db6ee35e00badefdc44dda07dce156f3d2ddf09c957621a9"
    sha256 cellar: :any_skip_relocation, monterey:       "3a7f81e0a6853c1b7787e8af2d1b497f14628fd0bd0cf8ba779d1b2222fe0f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "020978cd9fafb705dbe7581987db655e7a3ccce9b2ca51cbe38fad563cb6ac7f"
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
