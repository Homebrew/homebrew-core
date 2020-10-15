class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.3/downloads/hwloc-2.3.0.tar.bz2"
  sha256 "b607f6097873f69ef6b4b01e66e0dcb45f9939e8979827284664bbf0d4018a64"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "b98423329f95c10ee12f079edcdeae64b33f4639cd666d83e498805879d0cb4d" => :catalina
    sha256 "7ac08b2c072844864427cc80ec8906ea188ec3682a75578c149ade8148be3e66" => :mojave
    sha256 "72be3d1ae086a215fe867e34ffdf6da3e39b7571ceb6c8c5606035db24491d81" => :high_sierra
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
