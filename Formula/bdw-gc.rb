class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  license "MIT"

  # Remove stable block when patch is removed
  stable do
    url "https://github.com/ivmai/bdwgc/releases/download/v8.0.6/gc-8.0.6.tar.gz"
    sha256 "3b4914abc9fa76593596773e4da671d7ed4d5390e3d46fbf2e5f155e121bea11"

    # Extension to handle multithreading. Remove in v8.2.0.
    # https://github.com/ivmai/bdwgc/pull/277
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/f14c259aef209e5f5df302b834b2119381dd36d5/bdw-gc/crystal-mt.patch"
      sha256 "18380da9c5451c9b7668ccf5e1f106f8cf8115992d9a403e32444fb487566c33"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "55bdbcc825a5f4657ca307ed0a002e8cd07bb1635148962ff9187aca4b7dcb9c"
    sha256 cellar: :any,                 arm64_big_sur:  "788d86cb322a9409fb6e8117fc6ee48e57e3258a18b77a39f8682730caf2d239"
    sha256 cellar: :any,                 monterey:       "bdc97f40152e69b1b462021b1aa85cb97a134a6760bbdeba41a1d729a87c13d6"
    sha256 cellar: :any,                 big_sur:        "e1657498c65d958779349a5b3b2283e52e5c48cde79e26f761340bacfc3627e9"
    sha256 cellar: :any,                 catalina:       "0473379cc9c7dd97c1d28386e333702af1c2b98ae86b1564e5ef72fda94d395c"
    sha256 cellar: :any,                 mojave:         "45add006a7a827ea1b1828d2e5edb45b991cbb31906370d8270f511b781acfd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2de2bd6626902c0c6007c718d9bebdc9f653dcd58058f9f1a8cc0346fee8c8c7"
  end

  head do
    url "https://github.com/ivmai/bdwgc.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "gcc" => :test
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus",
                          "--enable-static",
                          "--enable-large-config"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>
      #include "gc.h"

      int main(void)
      {
        int i;

        GC_INIT();
        for (i = 0; i < 10000000; ++i)
        {
          int **p = (int **) GC_MALLOC(sizeof(int *));
          int *q = (int *) GC_MALLOC_ATOMIC(sizeof(int));
          assert(*p == 0);
          *p = (int *) GC_REALLOC(q, 2 * sizeof(int));
        }
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgc", "-o", "test"
    system "./test"
  end
end
