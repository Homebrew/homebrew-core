class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.15/gperftools-2.15.tar.gz"
  sha256 "c69fef855628c81ef56f12e3c58f2b7ce1f326c0a1fe783e5cae0b88cbbe9a80"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4028997c3d12b6e4885482ae58966354cc2fe80190c2a7ed135eb45e6b6276e0"
    sha256 cellar: :any,                 arm64_ventura:  "5e9f9b9c64f019690d06db1ffa1cef5de487afb374598685362c001a201a6ff0"
    sha256 cellar: :any,                 arm64_monterey: "d6c3548e117705df73fb52c00e11a365945b5ea8098f17525f53705b95309e8d"
    sha256 cellar: :any,                 sonoma:         "3deabed6495f3ae795e6d5be1b355bb18905708143286da8f14ca30f6a6cc1a7"
    sha256 cellar: :any,                 ventura:        "b01da38a247526e8165566ac8fafc6c2f752b1b3c528487f05fc1e66892060c9"
    sha256 cellar: :any,                 monterey:       "085fbccd71f4c121f530fcf4cf0e76602233b55c8f3b1f99a8ccc5be0a9b59d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25f20549f67205b20848e267614e039f03db0acc872ab78d2de1d76fd4b715d5"
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
