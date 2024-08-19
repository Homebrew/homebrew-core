class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.3.8/abyss-2.3.8.tar.gz"
  sha256 "3c262269043f619c79ec3dcd91f5595cb141229f9a13d1a76a952b9a0bfb0d84"
  license all_of: ["GPL-3.0-only", "LGPL-2.1-or-later", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end
  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d51aaa3ebeee8f2d7aafddbda19f362f8964bd438cc8cd882c4d449a34215aca"
    sha256 cellar: :any,                 arm64_ventura:  "ee601d3305bf086edc4537d6e47c62ae6203c7b20a8554cf13320cecf8c534d8"
    sha256 cellar: :any,                 arm64_monterey: "53684411c7bbb832019b78dba2e84c99a8172e81b8f580ea28f8bf3791c239dc"
    sha256 cellar: :any,                 sonoma:         "fd91fd250b60d771640582cb02d4d7b1b50003d17cf05152a7a8fce9e63dd5e0"
    sha256 cellar: :any,                 ventura:        "05f1bfc1159a8bd98b2258763927a02d64e691efab0440ee1c6ef386569a0506"
    sha256 cellar: :any,                 monterey:       "b941004f43971894244fbb61163f307bc74826544f714209ac7e0578eedbdf8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce78fd4fc24e5657de9f8eba20727e0eda20b78eb47e735306c93566810da1e9"
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
