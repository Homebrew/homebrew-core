class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.16/gperftools-2.16.tar.gz"
  sha256 "f12624af5c5987f2cc830ee534f754c3c5961eec08004c26a8b80de015cf056f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b4d276871df67ffac99cd78e33136c6c10cd03b7953fd2338157484eb98aa51c"
    sha256 cellar: :any,                 arm64_sonoma:  "98aaefc52161d42aaa50012e0d1f25f6b893f00369947bd72b5976be6651016e"
    sha256 cellar: :any,                 arm64_ventura: "d428485901b9144e3b3d95ce3f0c4b344e1760dedb9672251ede5c6fac05b3a7"
    sha256 cellar: :any,                 sonoma:        "b0f53d444765abb98c3c6756b4453898c59ff9664801f3f8f753b391e9481a1d"
    sha256 cellar: :any,                 ventura:       "11454d149fe95769f52b1a679b7543a377896b136ed8756934b2309b5e79ed4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "391faba3dacc74cd391006073abdc790c94121413482b602588a75218b67f51c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04f8ba407cd4997e7c0f62e25568c3216a36b1dbc50335b5a8c53351b4a73614"
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
