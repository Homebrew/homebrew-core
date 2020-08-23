class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.2.4/abyss-2.2.4.tar.gz"
  sha256 "f064a8c5ad152a37963d9001df6c89d744370f7ec5a387307747c4647360a47c"
  license "GPL-3.0"
  revision 1

  bottle do
    cellar :any
    sha256 "0fa7a8feaadb399933d3322c5df54136f47681481a26ec68ad535ff13cbd1f81" => :catalina
    sha256 "54adf813fa79009c9e6f942dfbd0bc4f0e4d76f04bd140fc1a9649df2ad23d6f" => :mojave
    sha256 "56eeaa001afb778129143c25566bf17f33e49099e2a1a08748444a6a77fed168" => :high_sierra
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
    url "https://www.bcgsc.ca/sites/default/files/bioinformatics/software/abyss/releases/1.3.4/test-data.tar.gz"
    sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
  end

  def install
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version >= :mojave && MacOS::CLT.installed?
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
