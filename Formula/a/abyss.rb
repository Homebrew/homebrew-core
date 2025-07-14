class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.3.10/abyss-2.3.10.tar.gz"
  sha256 "bbe42e00d1ebb53ec6afaad07779baaaee994aa5c65b9a38cf4ad2011bb93c65"
  license all_of: ["GPL-3.0-only", "LGPL-2.1-or-later", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end
  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4c97608ca2bb86304b77b4fddd3abee125f25971ba51495e95e6658b1ad5d1a"
    sha256 cellar: :any,                 arm64_sonoma:  "f4bdcdb91f2004e514df06e02f91d6341cb8d3f3ce32a9acf3958d37f1983f80"
    sha256 cellar: :any,                 arm64_ventura: "22819d8dfedb879c1f0742ec3f07e9090d99385b533bfc54158beddbe1eefadc"
    sha256 cellar: :any,                 sonoma:        "6bd97e0afea52bf21f3c0f01d10b2643c22c4aed6bf3e36cece3545d6ad6e9d1"
    sha256 cellar: :any,                 ventura:       "d81fe789736077b682ba6cbc7c62d89333ee560a7c2c02a0b3e936810e3cac1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbd181f4720f2c4e8f15d120f49bb2016a72e1eb7017dd8e046be245c424384a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cb253b94acc90a0619ef05ba23a178f9a28e8ee0395ffea66abbeb13500726f"
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
  depends_on "python@3.13" => :build # For btllib
  depends_on "gcc"
  depends_on "open-mpi"

  uses_from_macos "sqlite"

  fails_with :clang # no OpenMP support

  resource "btllib" do
    url "https://github.com/bcgsc/btllib/releases/download/v1.7.3/btllib-1.7.3.tar.gz"
    sha256 "31e7124e1cda9eea6f27b654258a7f8d3dea83c828f0b2e8e847faf1c5296aa3"
  end

  def install
    python3 = "python3.13"

    (buildpath/"btllib").install resource("btllib")
    cd "btllib" do
      inreplace "compile", '"python3-config"', "\"#{python3}-config\""
      system "./compile"
    end

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--enable-maxk=128",
                          "--with-boost=#{Formula["boost"].include}",
                          "--with-btllib=#{buildpath}/btllib/install",
                          "--with-mpi=#{Formula["open-mpi"].prefix}",
                          "--with-sparsehash=#{Formula["google-sparsehash"].prefix}",
                          *std_configure_args
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
