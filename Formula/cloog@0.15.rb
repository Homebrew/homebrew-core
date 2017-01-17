class CloogAT015 < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "http://repo.or.cz/w/cloog-ppl.git"
  url "ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-ppl-0.15.11.tar.gz"
  mirror "http://gcc.cybermirror.org/infrastructure/cloog-ppl-0.15.11.tar.gz"
  sha256 "7cd634d0b2b401b04096b545915ac67f883556e9a524e8e803a6bf6217a84d5f"

  bottle do
    cellar :any
    sha256 "927f1240d896e0844c13b327fdf8f1a446566fb1609104dcc407b4422923ffd1" => :sierra
    sha256 "797fdfe117784d713dcd56e48f1403f57a75fea2b6ae777e85c001c6b2fe9298" => :el_capitan
    sha256 "b6945a3a781be4c9d4ad3e866812f859055c8b8c53895bedf0b071e2741b7ab4" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "gmp@4"
  depends_on "ppl@0.11"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-gmp=#{Formula["gmp@4"].opt_prefix}"
      --with-ppl=#{Formula["ppl@0.11"].opt_prefix}"
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "CLooG", shell_output("#{bin}/cloog --help", 1)
  end
end
