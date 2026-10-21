class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.19/gperftools-2.19.tar.gz"
  sha256 "97adc4509128200e21f3b29cd0f1184d4a41cfad892750cd15e6b8f5b5f96f21"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "642bc7196deddcecda46f7194b158423d1942276d6938abee3986d5bae75c103"
    sha256 cellar: :any, arm64_tahoe:       "d3ff906f9eae5b6cc5947ec4fca0b17b8f2ccb61bef21cb548c0274e44328a3e"
    sha256 cellar: :any, arm64_sequoia:     "892b72bed00f6077b7c4c166e180a17d6b43e525f9a71a9dc4ec77d548d4aaa5"
    sha256 cellar: :any, arm64_linux:       "ed44f60ba0f3d59f69ab505b016d5b53003e1452d0030cec40e8c64cb10dcb60"
    sha256 cellar: :any, x86_64_linux:      "a14f497ea88a4ef9a72fa731bdaae384ea09d9173f47cc18aa836b16a0133ccf"
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
