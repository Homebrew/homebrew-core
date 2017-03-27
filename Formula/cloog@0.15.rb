class CloogAT015 < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "http://repo.or.cz/w/cloog-ppl.git"
  url "ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-ppl-0.15.11.tar.gz"
  mirror "https://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/infrastructure/cloog-ppl-0.15.11.tar.gz"
  sha256 "7cd634d0b2b401b04096b545915ac67f883556e9a524e8e803a6bf6217a84d5f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "44c06713c26b42ddc9cf13ec6a3d29181210dcc8d60c80e10e31415c022e1bf6" => :sierra
    sha256 "a81e2487e340bec8b5fcc1624f10f1786cdf046900cb433c51a728971e820342" => :el_capitan
    sha256 "6d542434511b3a90639672f3cd58e5495b5304516c7cf46c2fbf7483ad9494d8" => :yosemite
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
