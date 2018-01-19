class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.9.tar.bz2"
  sha256 "394333184248d63cb2708a976e57f05337d03bb50c33aa3097ff5c5a74a85164"

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
    system ENV.cc, pkgshare/"tests/hwloc_groups.c", "-I#{include}",
                   "-L#{lib}", "-lhwloc", "-o", "test"
    system "./test"
  end
end
