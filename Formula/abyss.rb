class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.2.1/abyss-2.2.1.tar.gz"
  sha256 "838c478b0fb5092e508f0253e213a820cd3faaa45546236f43b87a7194aa2cdf"

  bottle do
    cellar :any
    sha256 "b3b0b70dd3911e0a94689f1ff4c0066a77f1698d6644e948a70b6cc073d2bcae" => :mojave
    sha256 "465013b8098487135b82083d9a73562d27dd856a1a9707d9a7946032e9828e02" => :high_sierra
    sha256 "7202018eb50f51b0fc6c5ae76339e7dd2ae712f4a2dcc71e8dff9eb812878b54" => :sierra
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
