class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.6.2/gperftools-2.6.2.tar.gz"
  sha256 "4a28ff87bb8457f62fcf05487d78ccc3be4e4760dc89d4def5a5f26240407f23"

  bottle do
    cellar :any
    sha256 "1e6f41b6d61d05c1b48170218c90eda9822dc46cb3d69b6e7fb86bfd9613f4e1" => :high_sierra
    sha256 "fffac00b0bbf99aaa18fa437acb9204740ba8ab7cfdc1783a57d4d3d1af49ed3" => :sierra
    sha256 "eb634b147019b9b57fbe8b1daa709a74b95f2693b299b5bfd141cf63f01c18e4" => :el_capitan
    sha256 "74c85f5058535c1fd211e71ffe664f99d64aa392b4e56d4fa06c172900b2d9c2" => :yosemite
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
