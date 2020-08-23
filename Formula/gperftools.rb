class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.8/gperftools-2.8.tar.gz"
  sha256 "240deacdd628b6459671b83eb0c4db8e97baadf659f25b92e9a078d536bd513e"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "61a7c4f6c446b4ade0be332854baa8320a9cc193b00d89e39a0d3c18183aa8e3" => :catalina
    sha256 "efcfaff363bbb0508a50d2987f04cbe8dfa21bfb75e8d6388516ffefc0a74bff" => :mojave
    sha256 "55470b74d7c7567ca44429a1c1621cc2077dcadd2c6a8b4067f3812c3124f82c" => :high_sierra
  end

  head do
    url "https://github.com/gperftools/gperftools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Fix "error: unknown type name 'mach_port_t'"
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    ENV.append_to_cflags "-D_XOPEN_SOURCE"

    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
  end
end
