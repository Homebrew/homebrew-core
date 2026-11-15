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
    sha256 cellar: :any, arm64_golden_gate: "057c3bd0bcd5c262a0ef5cac163de4972775a0f7c01788f62b332cff232371fa"
    sha256 cellar: :any, arm64_tahoe:       "477269987e0cadd0b37c189417cb03068b81b39c0caef3ef8bdca9a7cff5d90f"
    sha256 cellar: :any, arm64_sequoia:     "752546c6762d3f6bc3cd54946a25ca737738d31a8bbcf41557fecc05eb541a5a"
    sha256 cellar: :any, arm64_linux:       "add4396d928ecf50f6bdf12d1861c0d9d40c94dc51d6db82ab1719ccfe8d9565"
    sha256 cellar: :any, x86_64_linux:      "2a0de312c40194661384c021b40f37b023801224ef6d77604e1e306c8f4b352e"
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
