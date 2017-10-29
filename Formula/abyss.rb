class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.0.2/abyss-2.0.2.tar.gz"
  sha256 "d87b76edeac3a6fb48f24a1d63f243d8278a324c9a5eb29027b640f7089422df"
  revision 1

  bottle do
    cellar :any
    sha256 "109472dfa59150418995609a8d6be995ca55b5bb64e89b104de3e15b2c5b7eca" => :high_sierra
    sha256 "b2a8142f2baf9cfebf9974a5aca1288ed4e20b923b7f48751dde8d34af0df9f6" => :sierra
    sha256 "0fdfb8e5e520247c515bcb5c283c019c71d3cf34c9a0318008b9048e2ae8b599" => :el_capitan
  end

  head do
    url "https://github.com/bcgsc/abyss.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  needs :openmp

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on :mpi => :cc

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
