class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.9/hwloc-2.9.1.tar.bz2"
  sha256 "7cc4931a20fef457e0933af3f375be6eafa7703fde21e137bfb9685b1409599e"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.mail-archive.com/hwloc-announce@lists.open-mpi.org/"
    regex(/[\s,>]v?(\d+(?:\.\d+)+)(?:\s*?,|\s*?released)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c27f24627823ce209b3249737f6dbd4b001f7ca23ed3e59896125a11bac579eb"
    sha256 cellar: :any,                 arm64_monterey: "f1fb60aa94a0409d191960c9e15b66061d0c1843a7f051cc2c7fc543fe85bda8"
    sha256 cellar: :any,                 arm64_big_sur:  "685c4d5588e835fdb628f36653218addc6f22ddf73ba2dc7b930a0e5ac97345f"
    sha256 cellar: :any,                 ventura:        "e8d0c2594d39615247ee63c1333482929b00321fee0feee0ce5f32e6b2a735ef"
    sha256 cellar: :any,                 monterey:       "e460c87fc7c3f905572610617d60bf761bea65eea81c52ee9089b73cb58c6f36"
    sha256 cellar: :any,                 big_sur:        "7661285898f8baf26255dd46388d767ca4459f96d19083762e8f5eed449d2c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bd836b802e40d21dce48e98a973cc0fb54e56ccb31d0f7054791c052946737d"
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
