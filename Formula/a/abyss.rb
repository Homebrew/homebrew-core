class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.3.7/abyss-2.3.7.tar.gz"
  sha256 "ba37780e79ec3aa359b6003e383caef13479a87f4d0022af01b86398f9ffca1f"
  license all_of: ["GPL-3.0-only", "LGPL-2.1-or-later", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79cb5a6c7414ad5b6a288a088ad472897edf7643dde0df8dba867f356aa4449c"
    sha256 cellar: :any,                 arm64_ventura:  "1ba7dce6f3cec234f9fab6d19711739ec64539124e034bbedc501dd8b6dacf48"
    sha256 cellar: :any,                 arm64_monterey: "2f8447dfaa29be848ed9cc343b2a10b6c4de902a3d1443907a8e2189a9ef894c"
    sha256 cellar: :any,                 arm64_big_sur:  "130faddf4d47b9296578726e486ec5ac8308b48f4d7b69ffe0aac4199bc61648"
    sha256 cellar: :any,                 sonoma:         "58082f4a3277be3a15ce05b9e202d5906f9066baec4f320013b58723511c81ad"
    sha256 cellar: :any,                 ventura:        "6ff3e90c05d2bf5e91a1df6891634942f93439e76f2af2c5946eee010fac065d"
    sha256 cellar: :any,                 monterey:       "0c42a5f6d2c6206c06c6131dd65c293741016f44623da7fcb382dce478af0ec6"
    sha256 cellar: :any,                 big_sur:        "f98e11643c56066529c0c0d9cd93f063442e57536d42790e1fc0f0313b96cbcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03715ef6459270e07f02d151223f14441bfbf8021e560cfec0ed239886c9654d"
  end

  head do
    url "https://github.com/bcgsc/abyss.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build # For btllib
  depends_on "google-sparsehash" => :build
  depends_on "meson" => :build # For btllib
  depends_on "ninja" => :build # For btllib
  depends_on "python@3.12" => :build # For btllib
  depends_on "gcc"
  depends_on "open-mpi"

  uses_from_macos "sqlite"

  fails_with gcc: "5"
  fails_with :clang # no OpenMP support

  resource "btllib" do
    url "https://github.com/bcgsc/btllib/releases/download/v1.6.0/btllib-1.6.0.tar.gz"
    sha256 "4a122c1047785dc865b8c94063714667f8ca43b8a881754eebd96dbb44fd1c3f"

    # Fixes 'uint' was not declared in this scope
    # Remove in next release
    patch do
      url "https://github.com/bcgsc/btllib/commit/43adf3d2671cc1ab780d23666e038055edb9d669.patch?full_index=1"
      sha256 "47e0f70501c8f5d543eb2a956a226f0a1a51816123a9b2061a081fb92c7b3f0c"
    end
  end

  resource "homebrew-testdata" do
    url "https://www.bcgsc.ca/sites/default/files/bioinformatics/software/abyss/releases/1.3.4/test-data.tar.gz"
    sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
  end

  def install
    python3 = "python3.12"

    (buildpath/"btllib").install resource("btllib")
    cd "btllib" do
      inreplace "compile", '"python3-config"', "\"#{python3}-config\""
      system "./compile"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--enable-maxk=128",
                          "--with-boost=#{Formula["boost"].include}",
                          "--with-btllib=#{buildpath}/btllib/install",
                          "--with-mpi=#{Formula["open-mpi"].prefix}",
                          "--with-sparsehash=#{Formula["google-sparsehash"].prefix}",
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
