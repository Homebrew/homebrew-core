class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.3.1/abyss-2.3.1.tar.gz"
  sha256 "664045e7903e9732411effc38edb9ebb1a0c1b7636c64b3a14a681f465f43677"
  license all_of: ["GPL-3.0-only", "LGPL-2.1-or-later", "MIT", "BSD-3-Clause"]
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_big_sur: "21d1cb2d31fa162cefea32db0630fc6011f8d3d0bb7ababa31f8e772820d1c7f"
    sha256 cellar: :any,                 monterey:      "817369d04fe421b42fc2ecb8aa631a93cb2f40fc49e24d8e377356801bdc7755"
    sha256 cellar: :any,                 big_sur:       "e56ce6b9bf533fb34bd2f87e87fb1019e3cccdcdc94d0e665e144121c95ddcad"
    sha256 cellar: :any,                 catalina:      "5a95037e8675013c34f4119d5a2914706ec3b99f522426878a19f27031ad4d79"
    sha256 cellar: :any,                 mojave:        "fc1208b6ff7dbcdc23d621076a271a40f1090cab41690ce35433c81425984494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36113b6fa458aaf594892cf86bbce9e0c6098285d42a3477dd9ffd85ecf06982"
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
      system "#{bin}/abyss-pe", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    else
      # Fix error: abyss-tabtomd: column: not found
      system "#{bin}/abyss-pe", "unitigs", "scaffolds", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    end
    system "#{bin}/abyss-fac", "ts-unitigs.fa"
  end
end
