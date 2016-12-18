class CloogAT015 < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "http://repo.or.cz/w/cloog-ppl.git"
  url "ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-ppl-0.15.11.tar.gz"
  mirror "http://gcc.cybermirror.org/infrastructure/cloog-ppl-0.15.11.tar.gz"
  sha256 "7cd634d0b2b401b04096b545915ac67f883556e9a524e8e803a6bf6217a84d5f"

  keg_only "Older version of cloog"

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
