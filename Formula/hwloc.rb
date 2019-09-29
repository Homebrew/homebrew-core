class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.0/downloads/hwloc-2.0.4.tar.bz2"
  sha256 "653c05742dff16e5ee6ad3343fd40e93be8ba887eaffbd539832b68780d047a9"

  bottle do
    cellar :any
    sha256 "d3688db66e47f68ff32d639d62d4cf745995ddd2a3e596d4e5b3ce3603f80916" => :catalina
    sha256 "471cf1870f1719d87422e9a66488bb98b9e9bcb6af3c8482ccf2c8d3dad66997" => :mojave
    sha256 "f57cbfaa45150def690a473468909743ea38dda08166977bde552b3c3fe5704e" => :high_sierra
    sha256 "0b13e2d51c3644d0dc8febe826d1ab845f15bc5f32f0bb08f7f1b7c95dfbd9ef" => :sierra
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
