class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.0/downloads/hwloc-2.0.4.tar.bz2"
  sha256 "653c05742dff16e5ee6ad3343fd40e93be8ba887eaffbd539832b68780d047a9"

  bottle do
    cellar :any
    sha256 "d290f5193bf9455ce1789b13ddabaf5aa38d1a72da98bc5fe063caf7390427e9" => :mojave
    sha256 "db1830961ee0aa952607ea8ac23226a584e0e0202ea4f2b9f2ac2499f5e2cd6f" => :high_sierra
    sha256 "ca80d65cb76a981a41fd347abda2ddfa8f2a9b44ec7cf3f90a551acc8f0e490b" => :sierra
  end

  head do
    url "https://github.com/open-mpi/hwloc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

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
