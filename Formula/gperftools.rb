class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.6.3/gperftools-2.6.3.tar.gz"
  sha256 "314b2ff6ed95cc0763704efb4fb72d0139e1c381069b9e17a619006bee8eee9f"

  bottle do
    cellar :any
    sha256 "970f65814aa7e7189bfd7102effcaa4319d4bb029b80381493173bbd0de0ac11" => :high_sierra
    sha256 "8b106fef7cbc78e541be3036d787db7250b202a04134228c6e107d82716f9616" => :sierra
    sha256 "d5a358bb519ac749c089f7fb5f4015f39579fb8f490223f3843cd55b7f1bcac6" => :el_capitan
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
