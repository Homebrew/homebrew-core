class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.16/hwloc-2.16.0.tar.bz2"
  sha256 "ad05eb466b915a4f0e0228173d7e09974ac38760c38d5b6f060254c050fca12d"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://www.open-mpi.org/software/hwloc/current/downloads/latest_release.txt"
    regex(/(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4c19c2e509ec4730569f93af374d728bf018739eb24d065424654ebe83ec0725"
    sha256 cellar: :any, arm64_tahoe:       "57c2792ce1624499ce1b5dabe5af80179ff6e722ed7d14ffa882835636bdd7c5"
    sha256 cellar: :any, arm64_sequoia:     "ee94ec61d74f506590e5498b938df7d068452e79685e784594d5ec48aa17b284"
    sha256 cellar: :any, arm64_linux:       "d69c3e8ece8e550570133666203dda31683a8b16f3ba0b9540245e4c74b9d5e6"
    sha256 cellar: :any, x86_64_linux:      "2429a479251d2d279ab5c200a2c9c8fab7844c354574c37ed8d3ac39490e66c5"
  end

  head do
    url "https://github.com/open-mpi/hwloc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  deny_network_access!

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--enable-shared",
                          "--enable-static",
                          "--disable-cairo",
                          "--without-x",
                          *std_configure_args
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
