class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.0/downloads/hwloc-2.0.1.tar.bz2"
  sha256 "b97575cc26751f252b5c9f5c00be94cab66977da2e127456a5ae2418649ec049"

  bottle do
    cellar :any
    sha256 "5bcf88dc51792ade5d02f04eaba01e723ee6bf0b603f8e109a26f22c7b430f15" => :mojave
    sha256 "2fc7869c8f5a177f38d5111f3bc0350e495e7282ee606eb5504a9a07fd6578b4" => :high_sierra
    sha256 "8988a34a4473a11290c4c2e7242dedc30f700653b4eec1483309b0d0bc1eb4d9" => :sierra
    sha256 "c406e6cc8a65ca3dfc6e6bf5a402f9538526583e8a46a579ae30c7253be54f7d" => :el_capitan
  end

  head do
    url "https://github.com/open-mpi/hwloc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cairo" => :optional

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make", "install"

    pkgshare.install "tests"
  end

  test do
    system ENV.cc, pkgshare/"tests/hwloc/hwloc_groups.c", "-I#{include}",
                   "-L#{lib}", "-lhwloc", "-o", "test"
    system "./test"
  end
end
