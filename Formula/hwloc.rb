class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.7.tar.bz2"
  sha256 "ab6910e248eed8c85d08b529917a6aae706b32b346e886ba830895e36a809729"

  bottle do
    cellar :any
    sha256 "3d87ff082922581fecb14af62b50e65b69c314935dd24e7a4750b8108a86e014" => :sierra
    sha256 "091d23471f53c3e6b5bbbb5f880734fb78a725e1dbb6d12541a0c6630141f68d" => :el_capitan
    sha256 "45891878bbe669bf29e2248cf73ed8487d35950d382278aba42b10d5a4bf9370" => :yosemite
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
