class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.12/gperftools-2.12.tar.gz"
    sha256 "fb611b56871a3d9c92ab0cc41f9c807e8dfa81a54a4a9de7f30e838756b5c7c6"
  end

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "544641aac87613e9a372be604b4cf74049a924cf8f9998d8c6bbaf16bbb1048a"
    sha256 cellar: :any,                 arm64_monterey: "0f6f0bfb2422e7d0bad20f4efc1b14057e8b6d2c324fe87d54f5241545770e83"
    sha256 cellar: :any,                 arm64_big_sur:  "2e7bd053cb4b19fd4baa5c8d3f5e320bcc9072c7d27ec72d549c62b0cc747f7c"
    sha256 cellar: :any,                 ventura:        "a24bfb67a31001cf9af30c8987620d031590362ed38b7324a3d61ca047a91c03"
    sha256 cellar: :any,                 monterey:       "62318959469fdf36e2478f5275eb515d2e8dea8bca4b8c707cafe56adfeba1cc"
    sha256 cellar: :any,                 big_sur:        "2e9667c2aa56f63b97a7676269b38e7a8eee275d0ed5d3ef3450ccad8716f92d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0529fb74df942233be49fe092c20cb3ea66c9b434050ad76c32183dcb085fc6"
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

  def install
    ENV.append_to_cflags "-D_XOPEN_SOURCE" if OS.mac?

    system "autoreconf", "-fiv" if build.head?

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
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <gperftools/tcmalloc.h>

      int main()
      {
        void *p1 = tc_malloc(10);
        assert(p1 != NULL);

        tc_free(p1);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltcmalloc", "-o", "test"
    system "./test"

    (testpath/"segfault.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      int main()
      {
        void *ptr = malloc(128);
        if (ptr == NULL) return 1;
        free(ptr);
        return 0;
      }
    EOS
    system ENV.cc, "segfault.c", "-L#{lib}", "-ltcmalloc", "-o", "segfault"
    system "./segfault"
  end
end
