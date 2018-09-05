class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.1.0/abyss-2.1.0.tar.gz"
  sha256 "fe28aee5e2ee24ea2c550518bfeb65577f8f9900831bf4fb0858ac1829fd86fa"
  revision 1

  bottle do
    sha256 "cced51c7524930f52dc80b4f7a5d444a58a1187d46a5bb1493cff54cbbfb9c05" => :high_sierra
    sha256 "ad906d48b6ae28236e962d4e0a5b23f8140fb1bbfa0e4a79832a71cfd34de296" => :sierra
    sha256 "2d3412f059574cc554ef1ae2fc50b952c9030aeefe6e413abb4a678a2c2bbf4f" => :el_capitan
  end

  head do
    url "https://github.com/bcgsc/abyss.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  fails_with :clang # no OpenMP support

  resource("testdata") do
    url "http://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/1.3.4/test-data.tar.gz"
    sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-maxk=128"
    system "make", "install"
  end

  test do
    testpath.install resource("testdata")
    system "#{bin}/abyss-pe", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    system "#{bin}/abyss-fac", "ts-unitigs.fa"
  end
end
