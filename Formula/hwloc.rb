class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.0/downloads/hwloc-2.0.2.tar.bz2"
  sha256 "14457d70e6f98ee9eb3f2940000da4bac99909a49560ef2fdf4eacd286410cde"

  bottle do
    cellar :any
    sha256 "1bab0bc7648791a559811cdc7135f54879aa5992948529942502279bdcdde3cc" => :mojave
    sha256 "f9d9eff8707c433e53322487dec416e7f55aecb115b33cdbd57a9e53d23898c2" => :high_sierra
    sha256 "403bc0d7b05a1a371be6b28f6732ec0758d35789a257330fd96f01c1162518f8" => :sierra
    sha256 "6cb2aca1177a2dea107e6edb32b9a4383de751a41290688b8fd1b4f55529fbac" => :el_capitan
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
