class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.12/hwloc-2.12.0.tar.bz2"
  sha256 "06a0a2bdc0a5714e839164683846a0e936a896213758e9d37e49e232b89c58d4"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.open-mpi.org/software/hwloc/current/downloads/latest_release.txt"
    regex(/(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "abc5173fdb1e8441a701efb7d3ae8f9214952cbf16e5da71d5a0f9656a0702ed"
    sha256 cellar: :any,                 arm64_sonoma:  "c60af835426f941a9a9afdb3174c89f3af17d305c269938bc278330fd0f4002b"
    sha256 cellar: :any,                 arm64_ventura: "8d669ce99bbc2ec2cccbaffc8c40de2699e8987270fe2268b3d943f18aade700"
    sha256 cellar: :any,                 sonoma:        "c225a90c17d6d38736b9e1a74ee85b63b0a86888c4dbf5935ff28b25b5240e50"
    sha256 cellar: :any,                 ventura:       "8e2f1a677f6982f2ad8517a1114bfb773356fc14c5c81a8da77c14b10a5aef45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b27ce6572ebf1505730dac09ebb79d96736dfcdf0b14bb35f83c747d088f7e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8fe14dfbcabf567c091b5d2a026546525665f76cf201f93064eddf49c146160"
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
