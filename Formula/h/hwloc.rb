class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.11/hwloc-2.11.2.tar.bz2"
  sha256 "f7f88fecae067100f1a1a915b658add0f4f71561259482910a69baea22fe8409"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.open-mpi.org/software/hwloc/current/downloads/latest_release.txt"
    regex(/(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e06b0910951fc93871258bc0470121dee0d30b8648a3486f28560b11b113aa4"
    sha256 cellar: :any,                 arm64_sonoma:  "3326ee8e9bc54d139eef489ace43a53cc0ea4bb1791cadef30f8ac7072923958"
    sha256 cellar: :any,                 arm64_ventura: "a9f8c1727ac42f73b51b014f71d0682200e7b08e3f46ed2e03a1db47ba58525a"
    sha256 cellar: :any,                 sonoma:        "2b05c795f132fb9cba84ec4b2e3b66ab3b8d819b807b3777dafe9b9e3dda1327"
    sha256 cellar: :any,                 ventura:       "02ca60d14701ebf17edfb09ce815dce1babf56006225d0b345223537fb9e8760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68ac02a2a9f8af59f6f453515f445c30a106c6cd34b2d947d6be71af103e96c5"
  end

  head do
    url "https://github.com/open-mpi/hwloc.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

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
