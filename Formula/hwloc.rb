class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.3/downloads/hwloc-2.3.0.tar.bz2"
  sha256 "b607f6097873f69ef6b4b01e66e0dcb45f9939e8979827284664bbf0d4018a64"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "dd1fcb52fa8c513dc264d359d2b71c847dfbc9c65d817ddc4254d2af97cf6e60" => :catalina
    sha256 "06104c9e69d96e85f4c914ef6bcae0a3275a0910a6a592b9d6ba1b20d2ad6301" => :mojave
    sha256 "05558ada03d18ac4e4a232ead53eb9f59ac5889a899dce4670cc3fe273438d10" => :high_sierra
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
