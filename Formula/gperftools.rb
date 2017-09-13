class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.6.1/gperftools-2.6.1.tar.gz"
  sha256 "38b467eb42a028f253d227fbc428263cb39e6c8687c047466aa2ce5bb4699d81"

  bottle do
    cellar :any
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
    ENV.append_to_cflags "-D_XOPEN_SOURCE"

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
    system ENV.cc, "test.c", "-L#{lib}", "-ltcmalloc", "-o", "test"
    system "./test"
  end
end
