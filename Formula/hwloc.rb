class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.7/hwloc-2.7.1.tar.bz2"
  sha256 "0d4e1d36c3a72c5d61901bfd477337f5a4c7e0a975da57165237d00e35ef528d"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.mail-archive.com/hwloc-announce@lists.open-mpi.org/"
    regex(/[\s,>]v?(\d+(?:\.\d+)+)(?:\s*?,|\s*?released)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "79d74dd3f15558150715098a5a639d9b08cbdf297e867bc863207bcd95ce8d0d"
    sha256 cellar: :any,                 arm64_big_sur:  "ab3450c99e27c6282dfb38a6cc62c4298555768877eb7fd0756a8a70f5269b00"
    sha256 cellar: :any,                 monterey:       "418855a04fc56557912cef120f882a23983fd7afd31a04078db3976b11b42788"
    sha256 cellar: :any,                 big_sur:        "3f0ebbc902aece206e2025bbf6970a3136d291bd9d8857907049e30ab8ffdf30"
    sha256 cellar: :any,                 catalina:       "c2706f7a282d00f815777df735d985c8ca50960c64c267d40308c85421eff331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5628c3a9c15eb78961338d90e76892643995535c96a0cc7b18eb4a5aabda42"
  end

  head do
    url "https://github.com/open-mpi/hwloc.git", branch: "master"
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
