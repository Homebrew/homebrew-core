class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.3.9/abyss-2.3.9.tar.gz"
  sha256 "55f0b27b67b4486dc6cbe132c0f4c228ee4f9e86c56292a7b50633df87e3212e"
  license all_of: ["GPL-3.0-only", "LGPL-2.1-or-later", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end
  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eab71545a0ab5f70d930a29ec2df154cd18a6c1deff38cc9aa9baa0e49076821"
    sha256 cellar: :any,                 arm64_sonoma:  "a1f94fa88a3c8137ab857855d083884a490e41ca9f689e388e3e9ef9c6feba85"
    sha256 cellar: :any,                 arm64_ventura: "0656d068375b742f0fd8013615429ba6fdfcf519988f368ebfe29182413aa2fe"
    sha256 cellar: :any,                 sonoma:        "d73c5710bda5819aaba920ed6348750f0bea013ebfcc90c8ef82fbb67e8f07e6"
    sha256 cellar: :any,                 ventura:       "977e8325243bff9552edd3571da6c386cff159949666426e0c81b54f70277f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a75c19295f8d2e58d1aaa762f9948c11513709d0ee85ca838fa41cb87ebae5cf"
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
    url "https://github.com/bcgsc/btllib/releases/download/v1.7.3/btllib-1.7.3.tar.gz"
    sha256 "31e7124e1cda9eea6f27b654258a7f8d3dea83c828f0b2e8e847faf1c5296aa3"
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
    resource "homebrew-testdata" do
      url "https://www.bcgsc.ca/sites/default/files/bioinformatics/software/abyss/releases/1.3.4/test-data.tar.gz"
      sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
    end

    testpath.install resource("homebrew-testdata")
    if which("column")
      system bin/"abyss-pe", "B=2G", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    else
      # Fix error: abyss-tabtomd: column: not found
      system bin/"abyss-pe", "B=2G", "unitigs", "scaffolds", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    end
    system bin/"abyss-fac", "ts-unitigs.fa"
  end
end
