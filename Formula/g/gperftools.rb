class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.19.3/gperftools-2.19.3.tar.gz"
  sha256 "7c8112efa6f7afb51d3ef0f4d5f307f16e8acd670bc63a88abf8260775d3eead"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "58aa206809daf99493855f0c240bd27b18d9f97309001da162b1c80d4297d72c"
    sha256 cellar: :any, arm64_tahoe:       "6288a03b5f162e1c71c02ed28fb1e52d76fb2a316a8a8ca3c4f48e3226a3bcf6"
    sha256 cellar: :any, arm64_sequoia:     "6cf12bc4aa6e928f6724fb779c2231643670f72ade811474779274b491785768"
    sha256 cellar: :any, arm64_linux:       "87f1377bd4ede18792c9c32b5e357a6ec715279d302880f10b018aa5ee0d1d60"
    sha256 cellar: :any, x86_64_linux:      "c757b7dc358994ed15eea974e7c824242bf7bd1b90509fb6c4b250dcd4bf964c"
  end

  head do
    url "https://github.com/gperftools/gperftools.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "xz"

  on_linux do
    # libunwind is strongly recommended for Linux x86_64
    # https://github.com/gperftools/gperftools/blob/master/INSTALL
    depends_on "libunwind"
  end

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]
    args << "--enable-libunwind" if OS.linux?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <gperftools/tcmalloc.h>

      int main()
      {
        void *p1 = tc_malloc(10);
        assert(p1 != NULL);

        tc_free(p1);

        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltcmalloc", "-o", "test"
    system "./test"

    (testpath/"segfault.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      int main()
      {
        void *ptr = malloc(128);
        if (ptr == NULL) return 1;
        free(ptr);
        return 0;
      }
    C
    system ENV.cc, "segfault.c", "-L#{lib}", "-ltcmalloc", "-o", "segfault"
    system "./segfault"
  end
end
