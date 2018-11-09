class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.1.4/abyss-2.1.4.tar.gz"
  sha256 "2145a1727556104d6a14db06a9c06f47b96c31cc5ac595ae9c92224349bdbcfc"

  bottle do
    sha256 "610e245c999a566af5d3d552d8729bdb95e05792b381bbb0a0dbb459bbb3a6af" => :mojave
    sha256 "28761a5c8f15f43c0d23bcecf3d18e9264be0aa531e3538b9131f08d350164d2" => :high_sierra
    sha256 "5b7a30aa0a90d9224e780ac8023a67a49eba773cd3f083475a87571c8a3bc804" => :sierra
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
