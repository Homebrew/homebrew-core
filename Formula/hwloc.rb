class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.8/hwloc-2.8.0.tar.bz2"
  sha256 "348a72fcd48c32a823ee1da149ae992203e7ad033549e64aed6ea6eeb01f42c1"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.mail-archive.com/hwloc-announce@lists.open-mpi.org/"
    regex(/[\s,>]v?(\d+(?:\.\d+)+)(?:\s*?,|\s*?released)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "24776d06b7bffff86a0b630f632311e915bf2e13b6ade10147ef0316732c0caf"
    sha256 cellar: :any,                 arm64_big_sur:  "ec52c24ada2a67d35ff6a3d576392b30f7bd61366419bcb604f9e2cc51e26adb"
    sha256 cellar: :any,                 monterey:       "3556f0917a9687896a1dccef7931154a62689ae101e9eec99a7ca3a16bdc1901"
    sha256 cellar: :any,                 big_sur:        "47cb88d780ba7caeeeeacd872e0926f1e1749643c3f01a7e5467db3878d12ddf"
    sha256 cellar: :any,                 catalina:       "1ee9a82784fe1f87f56bf9af612e8acb54824595d92ff029bd980144657cf524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d08eb8cb5828148edb35e598495e3ea8d5d4bb4bdda067f4786ad138eb1ccd2"
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
    system "./configure", *std_configure_args,
                          "--enable-shared",
                          "--enable-static",
                          "--disable-cairo",
                          "--without-x"
    system "make", "install", "bashcompletionsdir=#{bash_completion}"

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
