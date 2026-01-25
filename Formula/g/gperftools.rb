class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.18/gperftools-2.18.tar.gz"
  sha256 "a64c8873b63ebf631a5fc05af7f81f3ddf550c3bde37245e10311c7ae7a0c718"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5ddbbec95b03cc2717ca4721906d6d425dfa26ff9e2776d7df99fe3e151febb"
    sha256 cellar: :any,                 arm64_sequoia: "f6cec0c19db3e1ce8c38c7bad97f548e17d214214354b7d52527ddf50caa0f67"
    sha256 cellar: :any,                 arm64_sonoma:  "806f5a4604d5862b13aae63112492e9f5167239580f3a445b85f5973ba4232a6"
    sha256 cellar: :any,                 sonoma:        "a50ea7e3408f3bbe379970961e593c598b801c603cde6dd22e7b9f2c6fe221ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38d66d5119d2c884f05d4f13a0e9d7f95e681660e907a5cd5fcf89dcf2d07166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1968db6dba39ddad1ee9d8778f469a5434fda03d34e64b1106101410eaf3471b"
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
