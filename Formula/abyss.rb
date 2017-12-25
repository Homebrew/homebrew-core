class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.0.2/abyss-2.0.2.tar.gz"
  sha256 "d87b76edeac3a6fb48f24a1d63f243d8278a324c9a5eb29027b640f7089422df"
  revision 2

  bottle do
    cellar :any
    sha256 "bb42b5757cde66dcde18e1731e0a081f5e7f9182966ea562f72b32cd4e5d9ca5" => :high_sierra
    sha256 "8e9cd77ba6b8aba80b5914ef9a806ac2bc0ea9f6605331db06e1bf968c2e5528" => :sierra
    sha256 "4d89dd6066d55b4252a0707216dabf4e60065bdb2ad72cdb3a4d87a0bd70be80" => :el_capitan
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
  depends_on "gcc"
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
