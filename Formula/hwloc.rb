class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.6/hwloc-2.6.0.tar.bz2"
  sha256 "e1f073e44e28c296ff848dead5e9bd6e2426b77f95ead1792358958e859fa83a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9e4f9091f0ca0fd41860110eae7321f47de9a28e5acf97ecb2b19d07814c9893"
    sha256 cellar: :any,                 arm64_big_sur:  "65db4f4702d83cfd5556f995da893b2b1f2dd9e4c6c24b473a172e045cc98ba5"
    sha256 cellar: :any,                 monterey:       "2cea70038860388ab4c9de29c1a40643a5111d5732d0be5d8d7eb11f668ff864"
    sha256 cellar: :any,                 big_sur:        "78e23e24bf53daef2327eb3f792666fe02664a68015b0c66da99d8634ae1783d"
    sha256 cellar: :any,                 catalina:       "1afc6fa8a1b6ea25ed30da61fe81d6071d53cc57e91c59ef56a22b9c0cf8b0d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76293d573b2b335a31ba9f085cd87bc2eda7f5e84e84a7fb30d1a4cd11e14e18"
  end

  head do
    url "https://github.com/open-mpi/hwloc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--disable-cairo",
                          "--without-x"
    system "make", "install"

    pkgshare.install "tests"

    # remove homebrew shims directory references
    rm Dir[pkgshare/"tests/**/Makefile"]
  end

  test do
    system ENV.cc, pkgshare/"tests/hwloc/hwloc_groups.c", "-I#{include}",
                   "-L#{lib}", "-lhwloc", "-o", "test"
    system "./test"
  end
end
