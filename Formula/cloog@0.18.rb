class CloogAT018 < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "http://www.cloog.org/"
  # Track gcc infrastructure releases.
  url "http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.0.tar.gz"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.0.tar.gz"
  sha256 "1c4aa8dde7886be9cbe0f9069c334843b21028f61d344a2d685f88cb1dcf2228"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0510018effa230134f8976e06e54424e8a2a7aa0857bb9c178574eb044bfc6eb" => :sierra
    sha256 "874f95df2fe0c9243302c86eb551f207afe467ef9e56a3b54b08814459f1f125" => :el_capitan
    sha256 "1b72d502896aa6c2b67a56ef5dc5518fcd3a21fa8c4f56490d092b2e80cb1d27" => :yosemite
  end

  keg_only "Older version of cloog"

  depends_on "pkg-config" => :build
  depends_on "gmp@4"
  depends_on "isl@0.12"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gmp-prefix=#{Formula["gmp@4"].opt_prefix}",
                          "--with-isl-prefix=#{Formula["isl@0.12"].opt_prefix}"
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
