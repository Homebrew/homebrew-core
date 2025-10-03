class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.17.2/gperftools-2.17.2.tar.gz"
  sha256 "bb172a54312f623b53d8b94cab040248c559decdb87574ed873e80b516e6e8eb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dbafb6fc46196fd8f13dbd6b5fb6bd1b210d2ec9c28822a3ccf4d4d9f2039535"
    sha256 cellar: :any,                 arm64_sequoia: "ea34ae85c303bc4bd38232a7e93acd11389cb30c226ce3a911327af5e2149ded"
    sha256 cellar: :any,                 arm64_sonoma:  "c4f54ccf201211a79644147a84ab0814fc663fcedc1b57063db050669ddebb31"
    sha256 cellar: :any,                 arm64_ventura: "5689a65cbb0c98429fe13d949bd36ab1b9d9ad7f2479b435ed6aa798f2b5141e"
    sha256 cellar: :any,                 sonoma:        "bb84872e1e25b83e86d5a500f4bdce56b37ec695f954d7e236d8678da1f08f77"
    sha256 cellar: :any,                 ventura:       "9d95e1494ecc17ce5a48221a96fe3a44f94d9d80274299721756f2b04b645b16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b6226ec9a1b380f27e00c0ff377b7b2bab468f0ce70856d988730f3aa803957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b90e19dd7b237b02aff6d7ddd13fcabdb68ce97e9b27a0d43df8746eeea33c3"
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
