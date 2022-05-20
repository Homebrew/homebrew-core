class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.3.5/abyss-2.3.5.tar.gz"
  sha256 "5455f7708531681ee15ec4fd5620526a53c86d28f959e630dc495f526b7d40f7"
  license all_of: ["GPL-3.0-only", "LGPL-2.1-or-later", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1e541d242060ab3e5ff9544a4a9fe61327824692e3ad8ee37db2a52709683b74"
    sha256 cellar: :any,                 arm64_big_sur:  "0ce0917d17014e1a82c1928695fb87b3a5dcaaec638feb9e97a9e0f536e3c813"
    sha256 cellar: :any,                 monterey:       "74d2f18f1d5bce6c64fd8c0cdb3107d754c6e4e047d8a51c5374bdd197534149"
    sha256 cellar: :any,                 big_sur:        "530b0b23c9af599146f4acf2ca548a4881b02e96e16adc11606cbafb41dfe802"
    sha256 cellar: :any,                 catalina:       "9a6e75c4710d0e7d9ca55119250defb2f82ac1295882f809e5bc669e8e446386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1023cb4e3ee62d6feec535b310d4d9957e8517cedc032d16e2245fb43e750070"
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

  fails_with gcc: "5"
  fails_with :clang # no OpenMP support

  resource "homebrew-testdata" do
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
    testpath.install resource("homebrew-testdata")
    if which("column")
      system "#{bin}/abyss-pe", "B=2G", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    else
      # Fix error: abyss-tabtomd: column: not found
      system "#{bin}/abyss-pe", "B=2G", "unitigs", "scaffolds", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    end
    system "#{bin}/abyss-fac", "ts-unitigs.fa"
  end
end
