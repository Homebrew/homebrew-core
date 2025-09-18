class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.12/hwloc-2.12.2.tar.bz2"
  sha256 "563e61d70febb514138af0fac36b97621e01a4aacbca07b86e7bd95b85055ba0"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.open-mpi.org/software/hwloc/current/downloads/latest_release.txt"
    regex(/(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "baedf023ef614fc146195b2d63d8bd7fd73cc17de666765961f589dd27ba9d79"
    sha256 cellar: :any,                 arm64_sequoia: "356391e580cf546a4b1b4180fa630a64ba6bd7bf00164914b58e41f0f2fa2cea"
    sha256 cellar: :any,                 arm64_sonoma:  "3eedeb79b2c25c7bb3b5fbe2a3a25f60b9c05779b75db2d871bdaf560b6a7c38"
    sha256 cellar: :any,                 arm64_ventura: "fd80369eabf2c1ae59af139efb7bf7d31becf28112e662630ead948e6ee0bf63"
    sha256 cellar: :any,                 sonoma:        "567c5b15c6b01b8702b87230d517f6d12573d46d396830e5fc5fae13745a2888"
    sha256 cellar: :any,                 ventura:       "4710f1b590faecc187f6d7d9b44053e7ac7d986ab55ba7d67b91539f93155170"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eac8d23df5e4d723bf09c5cc5d245e76e6ae35e37b8ed708300090d0cbf672e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e89ad68f540bc1c8ebe958702be09680dbfb67b9f249ea7b8867088e4a05e4d"
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
