class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.18.1/gperftools-2.18.1.tar.gz"
  sha256 "d18d919175f9e4d740ace6b52f0f4f91284160c454e91b36ffd6456282a02206"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "441be19e92f18df04aacfbe09dffe235c9bf8b070c5d5e3f8db6611c9890c23d"
    sha256 cellar: :any,                 arm64_sequoia: "8cc759dba8cf08fe71fd36cf585b6a626bd22bd41718c26616eefa665443b383"
    sha256 cellar: :any,                 arm64_sonoma:  "5dc611bd687d0b5b3ddadf2f200edcedad5d95b6f07d45324bb782e62d57d750"
    sha256 cellar: :any,                 sonoma:        "96980b401d0332ec875685001597fee2a37006f40bd1e92d55bf53fa315c62bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6cf2911544eb57a83f4baeaf71e7b5e9b905af8c31d73461306cdf3bf5a728f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dafaf048a2e362d06592fa527fba49a22eefa29f66c60edb14a10e9edbf0876"
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
