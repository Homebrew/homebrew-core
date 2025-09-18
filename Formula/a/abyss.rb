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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "81c78f4aadee3c4fb25110d257c115e806d14b437e96d27e77fc4b84a328eafa"
    sha256 cellar: :any,                 arm64_sequoia: "e101572d7d3f7ec6a519888e90d8202da080add1d774105b406712a5920b68a8"
    sha256 cellar: :any,                 arm64_sonoma:  "8568ca8de272baac70ea8233665436f6ba0bd26156f5ae6a9eebc9c9a26df696"
    sha256 cellar: :any,                 arm64_ventura: "0183a197b480d32b9063da4d7d16bdf9e347f9b3e1417b18577d5c1c3fbdeb95"
    sha256 cellar: :any,                 sonoma:        "7a18163b240f0cd8b95da2dc9b4df409a4f49f56ce24c9032185237a45de08ea"
    sha256 cellar: :any,                 ventura:       "f14bb039e937d63c3b856bcb51252ef98faf80f0f972220e753eaefd52645157"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f64a28e719e394fcf696127bd2906ab59bcd1d7a5765ae51f36876e533d4389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "246d74b2ccc4a225327db691de91a9e89731052c2b1443040d4ed1870483c7a7"
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
  depends_on "open-mpi"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
  end

  resource "btllib" do
    url "https://github.com/bcgsc/btllib/releases/download/v1.7.3/btllib-1.7.3.tar.gz"
    sha256 "31e7124e1cda9eea6f27b654258a7f8d3dea83c828f0b2e8e847faf1c5296aa3"

    # Apply FreeBSD patch to fix build with newer Clang, https://github.com/simongog/sdsl-lite/issues/462
    patch :p0 do
      url "https://raw.githubusercontent.com/freebsd/freebsd-ports/af74f60a871e4a5aa7aea787fc235a2cb760e764/devel/sdsl-lite/files/patch-include_sdsl_louds__tree.hpp"
      sha256 "84aef67058947044c40032ac39d9b6d1b8a285c581f660d565cd23aaa4beade7"
      directory "subprojects/sdsl-lite"
    end
  end

  def install
    resource("btllib").stage do
      with_env(CMAKE_POLICY_VERSION_MINIMUM: "3.5") do
        args = %w[-Db_ndebug=true -Db_coverage=false]
        system "meson", "setup", "build", *args, *std_meson_args.map { |s| s.sub prefix, buildpath/"btllib" }
        system "meson", "compile", "-C", "build", "--verbose"
        system "meson", "install", "-C", "build"
      end
    end

    # Help link to libomp on macOS
    ENV["ac_cv_prog_cxx_openmp"] = "-Xpreprocessor -fopenmp -lomp" if OS.mac?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--enable-maxk=128",
                          "--with-boost=#{Formula["boost"].include}",
                          "--with-btllib=#{buildpath}/btllib",
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
