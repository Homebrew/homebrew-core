class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.4/downloads/hwloc-2.4.1.tar.bz2"
  sha256 "392421e69f26120c8ab95d151fe989f2b4b69dab3c7735741c4e0a6d7de5de63"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c9fee522e4e68aef27a0f89e4eaacc1040571d53d784109821ccfbc492666b3d"
    sha256 cellar: :any, big_sur:       "2128d93734fe007235ae4dc6222d02c4d3f7e1faf06529cbf2a7926d6819f64a"
    sha256 cellar: :any, catalina:      "472c55e16e5ad6b615f41eb323565533a31e7c8cc05add78106a856be31cf3cf"
    sha256 cellar: :any, mojave:        "747f91410adfd6735acc68a230088b3ddb39024e508f376cc64752d6db3c8dff"
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
