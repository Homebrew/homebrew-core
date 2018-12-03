class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.1.4/abyss-2.1.4.tar.gz"
  sha256 "2145a1727556104d6a14db06a9c06f47b96c31cc5ac595ae9c92224349bdbcfc"
  revision 1

  bottle do
    cellar :any
    sha256 "2594b278174b438b266bd33e524673ae710e9b92685643560f4662f701ed03bb" => :mojave
    sha256 "90d14e10505c717540957ed66b5cdbe21d504c3cb915468e0035bbd2b649d704" => :high_sierra
    sha256 "c70867415966ccf4a7c69fdd90d6f265f7613f49023463ff1c3f06c058d7c36c" => :sierra
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
    # Fix a compiler error. Remove with the next release of abyss.
    # See https://github.com/bcgsc/abyss/commit/195f19bba03fec18d86cd931b34275222ba667fc
    inreplace "lib/bloomfilter/BloomFilter.hpp",
              'strncpy(header.magic, "BlOOMFXX", 8);',
              'memcpy(header.magic, "BlOOMFXX", 8);'

    system "./autogen.sh" if build.head?
    system "./configure", "--enable-maxk=128",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].include}",
                          "--with-mpi=#{Formula["open-mpi"].prefix}",
                          "--with-sparsehash=#{Formula["google-sparsehash"].prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    testpath.install resource("testdata")
    system "#{bin}/abyss-pe", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    system "#{bin}/abyss-fac", "ts-unitigs.fa"
  end
end
