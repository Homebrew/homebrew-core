class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "644f544af3755492aba0a9de3e9d66f95119ddc12987b384aed2bca8473486dd"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff6dc821e5766d8a07397f283ff7a09730cedc5831b22d1aec4bf7477b4a0661"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fc5d80396efc066e7b3d39d6d6cb1013a262d90537436881d6c5f4d31a1252f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8283b43f8b8c42817fc18b706572414a648e7edf81e7d33bde21b4ef99fb1488"
    sha256 cellar: :any_skip_relocation, ventura:        "4d707ffde8704668f1ac1ddd454c3a7449b5965af0016409864dd68892fa3754"
    sha256 cellar: :any_skip_relocation, monterey:       "181ef7e362dc7c3d2615a86c0704f323a17f35858a1a532e626d300022dff3ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0eb3967a25cfa39381b739fde006359382ada0e8557270cf12c3d981e925945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d156b24ee69c1b56e4ffefa17d7bcd8a9698c8f80fbc8f310a62485fafef9ab"
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
