class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.1.1/abyss-2.1.1.tar.gz"
  sha256 "aca9e5ad984282ced81038dfc20205ba0bb59ff4edf427419451b632aa567e9f"

  bottle do
    sha256 "80ab108b5ce547a63be711284367e2a29c7657eeee4f23ac0da1ec621113fe5f" => :mojave
    sha256 "47829fcb41eca26386d6c5db4b2d3d7ff999205ddea5db86059911cbd426fa3f" => :high_sierra
    sha256 "48729e38eecf5f49df1f05654a80e0539f5b44732f6ec43856e68b108dd96bce" => :sierra
    sha256 "e82ef97ceb8f9e93afd70c435fbf5798b15a96d7dd9c86e6cd79713c0064cc15" => :el_capitan
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
