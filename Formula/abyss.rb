class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.0.3/abyss-2.0.3.tar.gz"
  sha256 "ff4cb9c9f78e443cc5b613dbc1f949f3eba699e78f090e73f0fefe1b99d85d55"

  bottle do
    cellar :any
    sha256 "60bcabf8bd9ac360375dcdd6d0e1d91948afaa75a927db046451d56c5f98a9fc" => :high_sierra
    sha256 "e9b510c1c7493d0e1cfe375f1b93ef8bd01b39530092fc90832fe8328e0bf96e" => :sierra
    sha256 "89ba22f587e19cc562ae25ba3c5986fcc16b113df704268b01bd354feb55269f" => :el_capitan
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
