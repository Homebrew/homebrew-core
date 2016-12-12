class CloogAT018 < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "http://www.cloog.org/"
  # Track gcc infrastructure releases.
  url "http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.0.tar.gz"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.0.tar.gz"
  sha256 "1c4aa8dde7886be9cbe0f9069c334843b21028f61d344a2d685f88cb1dcf2228"

  bottle do
    cellar :any
    sha256 "ce68d6fe432603b7c52cb6502eb1cac6fe89cb3fd5d39d28a9f28a8d422b78d9" => :sierra
    sha256 "41d9d79f23da5752a2c3c9ca2b3489de8dd1eedf55e6d7b5226fc38e9d19037f" => :el_capitan
    sha256 "875b986395c3e98d5bf5cbeab803c47cbb7668ccebb57f8550c56019ef922a18" => :yosemite
  end

  keg_only "Older version of cloog"

  depends_on "pkg-config" => :build
  depends_on "gmp@4"
  depends_on "isl@0.11"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gmp-prefix=#{Formula["gmp@4"].opt_prefix}",
                          "--with-isl-prefix=#{Formula["isl@0.11"].opt_prefix}"
    system "make", "install"
  end

  test do
    cloog_source = <<-EOS.undent
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    assert_match "Generated from /dev/stdin by CLooG",
      pipe_output("#{bin}/cloog /dev/stdin", cloog_source)
  end
end
