class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.3.4/abyss-2.3.4.tar.gz"
  sha256 "7bbe479d2574a4d0241a5f564852d637690ded165c160862977e90597c614fed"
  license all_of: ["GPL-3.0-only", "LGPL-2.1-or-later", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ecb144d0ac3aa901b601a7feaceca7ca3dd15f109b509680234f77a1d6d733ce"
    sha256 cellar: :any,                 arm64_big_sur:  "c616dc93d3c6e3815cc3552780c90a5c151e10492388ceb132b29c005954ad28"
    sha256 cellar: :any,                 monterey:       "483ae98a1d98b13273e05cb41e8bed12c7a79578065390750aac0c4c89d85be7"
    sha256 cellar: :any,                 big_sur:        "5f6eb38e8fb09b0fd44b5a009da45c614ebce39d067ed61d0de319e816f02654"
    sha256 cellar: :any,                 catalina:       "4c1c980211e1e2f6a214746ea2c1386afb47d10dbb0ab00ea478784668815e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c145191f987d15368189ea9b83b2bd2bf03f63d5494dafbbe32fa5880f57f30c"
  end

  head do
    url "https://github.com/bcgsc/abyss.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

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
    if which("column")
      system "#{bin}/abyss-pe", "B=2G", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    else
      # Fix error: abyss-tabtomd: column: not found
      system "#{bin}/abyss-pe", "B=2G", "unitigs", "scaffolds", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    end
    system "#{bin}/abyss-fac", "ts-unitigs.fa"
  end
end
