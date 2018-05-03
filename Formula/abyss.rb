class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.1.0/abyss-2.1.0.tar.gz"
  sha256 "fe28aee5e2ee24ea2c550518bfeb65577f8f9900831bf4fb0858ac1829fd86fa"
  revision 1

  bottle do
    cellar :any
    sha256 "acdb468b09749fac482d728f1db9fa79e7376804899bcff2fb1990c23ba1e7e8" => :high_sierra
    sha256 "0fff6087e6e48334b71dca0278c11f6034a63b479a20b39c506577331d3bb0a3" => :sierra
    sha256 "fff845dad99976c10443a77f3970a062aabb71bebbfcfb9a38c6d2a6ae0541be" => :el_capitan
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
