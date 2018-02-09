class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.0/downloads/hwloc-2.0.0.tar.bz2"
  sha256 "99e56f72d21f4e9c449b57f602ef72d79bf0a2e2ff5fb77367fd1a9f5c312708"

  bottle do
    cellar :any
    sha256 "16e2b2833e9754ddad6047791f400dfb8c05984c488a8e1779d025d150e34603" => :high_sierra
    sha256 "ed3ba29ff0ca138fdb7742b4c8acc15e3f181c7ec7f881a1b58197f48768e3fa" => :sierra
    sha256 "30d05f71caeb57cd9ad0453ed9fb4096a6158faef4f1de859e684825399cdeb1" => :el_capitan
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
