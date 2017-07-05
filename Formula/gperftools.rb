class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.6/gperftools-2.6.tar.gz"
  sha256 "87d556694bb1d2c16de34acb9a9db36f7b82b491762ee19e795ef2bef9394daf"

  bottle do
    cellar :any
    sha256 "f007d19e148f697e681ba71f9c3721ec1f9640b7a48bd0a55c129085ba1a3a89" => :sierra
    sha256 "f29fe0e250ee9cc6cba00dc839bf0097db992ba4ec11aff4ab9dbd69e7dd10e8" => :el_capitan
    sha256 "e6af4a9899529cf2aa1ab0c7c6a667cf1a1df9a207a51c0dbb64128d1e1f1d05" => :yosemite
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
