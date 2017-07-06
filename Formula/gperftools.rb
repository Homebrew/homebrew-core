class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.6/gperftools-2.6.tar.gz"
  sha256 "87d556694bb1d2c16de34acb9a9db36f7b82b491762ee19e795ef2bef9394daf"

  bottle do
    cellar :any
    sha256 "88b926680de61012eb3fa138ed594a78e58952788f5c308d4fc9275b52311774" => :sierra
    sha256 "a2edc2ec0e885b4bdb31ccc32f82f3ed6dcf87fb771860c2e4255b21717f9c2e" => :el_capitan
    sha256 "b80ed7e1c907d37f2d8f226158234c5a148269ce0478651a7e1f14e2865f9234" => :yosemite
  end

  head do
    url "https://github.com/gperftools/gperftools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.append_to_cflags "-D_XOPEN_SOURCE"

    # Workaround for undefined symbol error for ___lsan_ignore_object
    # Reported 5 Jul 2017 https://github.com/gperftools/gperftools/issues/901
    ENV.append_to_cflags "-Wl,-U,___lsan_ignore_object"

    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
    system ENV.cc, "test.c", "-ltcmalloc", "-o", "test"
    system "./test"
  end
end
