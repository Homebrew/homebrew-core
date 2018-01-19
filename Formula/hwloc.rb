class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.9.tar.bz2"
  sha256 "394333184248d63cb2708a976e57f05337d03bb50c33aa3097ff5c5a74a85164"

  bottle do
    cellar :any
    sha256 "42fd04fddcdd334ae55ed72dbb5dec7466d9d785a7886cd71d610b2669678bfd" => :high_sierra
    sha256 "e640a44067de9f1d7f7b4b6095dc557f0e49257147f600ae23a81fed9eb52e7c" => :sierra
    sha256 "4a4105e5afc225caddb404a96b0e1412d4f54f2bf8327c67c7f9b58361ae31cc" => :el_capitan
    sha256 "6bb7c10ee374d13567853009bf376a97230b880aedde7e9bfce6a61441742c76" => :yosemite
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
