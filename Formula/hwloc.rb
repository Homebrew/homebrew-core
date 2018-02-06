class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.0/downloads/hwloc-2.0.0.tar.bz2"
  sha256 "99e56f72d21f4e9c449b57f602ef72d79bf0a2e2ff5fb77367fd1a9f5c312708"

  bottle do
    cellar :any
    sha256 "639f5ae402481d9f8ff540e1d5131ba037791c585fbfdc26e58850b00428e46d" => :high_sierra
    sha256 "5ba351fdb5f165f29f00428f5ea429c055a59914e0691577a5e02500c5dc6c21" => :sierra
    sha256 "e3ea9be003573ee1d254c38f2ddf65de8c7d18a4fcedc87545825d796d19341e" => :el_capitan
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
