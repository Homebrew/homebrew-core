class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.13/gperftools-2.13.tar.gz"
  sha256 "4882c5ece69f8691e51ffd6486df7d79dbf43b0c909d84d3c0883e30d27323e7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "732e4d9aab72c1e28c50304fd726e9b41b2847b87fde57965ab76b947968719d"
    sha256 cellar: :any,                 arm64_monterey: "38be747816f190d6159f2b70201f6204103bc4a61b07343eec0fbe7554591d27"
    sha256 cellar: :any,                 arm64_big_sur:  "65d89f828d675f4dc6ee4fdaf976ee70369d13d34025cc2b30e7d6d4b5eb5b5a"
    sha256 cellar: :any,                 ventura:        "93a8cc2a328a8a5a3705afd6c6b6072b29e414312a9f165cc0bb3a5dccc55e7b"
    sha256 cellar: :any,                 monterey:       "56e939770b774daf8016ae1151af8f412f5492d84e526a841d0fc317603e41a6"
    sha256 cellar: :any,                 big_sur:        "5ac2fab24732f5a0577f78d7070241ad0c5ace97914a3099a6834560744ea343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b39cc229b25a9d759be53d21a6f9a0fdc12e028ec9054b3671795b6998f0b7ed"
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
