class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.11/gperftools-2.11.tar.gz"
    sha256 "8ffda10e7c500fea23df182d7adddbf378a203c681515ad913c28a64b87e24dc"
  end

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6c6c3e16fa7fca30205f400257f5eb427c27d704098cc9c266c9897bdf8e09bd"
    sha256 cellar: :any,                 arm64_monterey: "5f51a35d4055b548a42ad3e0009e5bf44a1dc15dcd4d3319fe9b86587e6ec916"
    sha256 cellar: :any,                 arm64_big_sur:  "d8c4a525a638167330f07fe519214efdae76cd141d08cd7a82a24af3f8ad382c"
    sha256 cellar: :any,                 ventura:        "36b66a37fb05abbed3ae165b902115f0cdca3917fe234ef05a43a0927b65cda3"
    sha256 cellar: :any,                 monterey:       "b5748b86f6ae4a051de593243800bffca453c3fd8bfbe222baa657388c3aa28b"
    sha256 cellar: :any,                 big_sur:        "a88112dfe2cff88a50d8c8634ba45a45b803693b9bc8cefba2e7b6dfa6a13e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6c55e7d9c2aabda701076d96dcddb7688b0809e5a56780649ae396871ec603"
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
