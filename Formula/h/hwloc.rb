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
    manifest_sha256 "d6064db562dc2b3380179ae314c639e0f5faa7a19b9881a002c3264be235a2a5"
    sha256 cellar: :any, arm64_golden_gate: "c0b62d65c0f5865468d380b55d02da120d54b22a813d69408c7dfb488a7b7f92"
    sha256 cellar: :any, arm64_tahoe:       "ff18d6b1f50d604331341e9a061426ad3379add277cab1f4554602cca3357966"
    sha256 cellar: :any, arm64_sequoia:     "1392635c0406064a026dd2a07dd7a130b2ca04caf9389ccf68c777e5d19444bd"
    sha256 cellar: :any, arm64_linux:       "095b3342f4603691b0b5bfa52a856d2ba3a9edc9067a593c790cbe62fd6fdff7"
    sha256 cellar: :any, x86_64_linux:      "ca6bd3d33f100800402246076aa743b211bfb3164138ae9676de95b7073e18e2"
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
