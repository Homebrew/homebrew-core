class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.4/downloads/hwloc-2.4.0.tar.bz2"
  sha256 "2b1f1b4adb542911096bdceceb16270e9918908dcd884ab85c2f929c2b3838e9"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "ec7b2827de6ecaf19af60fe5c0b17cfca16a04adba68a12cd77b861d83c0311e" => :big_sur
    sha256 "c2e4c957e5d881fbbf136ce97b14c7fd90a4bd9ed0eba7c786c9cac3e0429736" => :arm64_big_sur
    sha256 "2891b4a4c672422f8a9c45083ec2ac39aeafc1cbdbc9d0446718f783a326d330" => :catalina
    sha256 "0b8cd8f304cedc64e8e2c47fc37b67e129c6cbb67d945d0147403259ad289f29" => :mojave
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
                          "--disable-cairo",
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
