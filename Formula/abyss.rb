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
    sha256 cellar: :any,                 arm64_monterey: "ddaf94b4cc55d9eeba4af66371607f9b52d88f63199be9d8dca4b35a1e174409"
    sha256 cellar: :any,                 arm64_big_sur:  "778a4b29c03b0e5a1157690e78a53ac4ed82dc881f59a42f416772be9194967e"
    sha256 cellar: :any,                 monterey:       "c2e61ff154139048e0ffdd23dc2389344646a81ffbf7a211ec665d39cdb607f8"
    sha256 cellar: :any,                 big_sur:        "ed5226b1b597566cbf966d7bf4cfc560027a5279ef444c1de2abad38ffaea5c6"
    sha256 cellar: :any,                 catalina:       "d50e051d08efd49321441dbcccd8973505d9f5e75a5b5a126946ca41e5f2a673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90f95159abd04629455507380bb7fd86ece2e658b1009b3c4dbd48fe0f934f2a"
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
