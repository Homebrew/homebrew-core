class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.12/hwloc-2.12.2.tar.bz2"
  sha256 "563e61d70febb514138af0fac36b97621e01a4aacbca07b86e7bd95b85055ba0"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://www.open-mpi.org/software/hwloc/current/downloads/latest_release.txt"
    regex(/(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2018718c080f9e5fcc9556800857327d7e3ca8d3b61e33099697bbc1d55cfd7a"
    sha256 cellar: :any,                 arm64_sequoia: "bc1ad16844c07c32e1b3e96f58e33cb10079cfa464838e43e027a1c8314cb846"
    sha256 cellar: :any,                 arm64_sonoma:  "a1290bff135b7759e68b6a5c221c6dad640676d0d95de6764bda04bee3d7f3cd"
    sha256 cellar: :any,                 sonoma:        "cb64e9f5c6fb775c6b16204ca8937500db9d590ce7a1693e54a13f9598b53c51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e37887e285f3808eaf5dfa5ed3bd6b6b07d789aba2c017541b68947527e89ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16f5daa770492c2cd80557fc3ba5f3de4e502502d6db5a95452fad8e1d0d5a62"
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
