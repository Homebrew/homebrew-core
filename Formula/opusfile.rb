class Opusfile < Formula
  desc "API for decoding and seeking in .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opusfile-0.11.tar.gz"
  sha256 "74ce9b6cf4da103133e7b5c95df810ceb7195471e1162ed57af415fabf5603bf"
  revision 1

  bottle do
    cellar :any
    sha256 "880361a708feef58ac653b5d75c8097424e5b3103a7ff00ac147020de1b7d925" => :catalina
    sha256 "3ed382fc35e4038c6453b73f7f4de91563c5d46ec42661ef0c6f2fc3ce73f0fa" => :mojave
    sha256 "a02bf319a06dce9af3eb978a1cc4f787883bdbe64aa2085f7e30279bee27d732" => :high_sierra
    sha256 "ec6639a35be7e6c52129231be4c20e1d078bea09862ee573ecaf359a5c3cd7d6" => :sierra
  end

  head do
    url "https://git.xiph.org/opusfile.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "openssl@1.1"
  depends_on "opus"

  resource "music_48kbps.opus" do
    url "https://www.opus-codec.org/examples/samples/music_48kbps.opus"
    sha256 "64571f56bb973c078ec784472944aff0b88ba0c88456c95ff3eb86f5e0c1357d"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <opus/opusfile.h>
      #include <stdlib.h>
      int main(int argc, const char **argv) {
        int ret;
        OggOpusFile *of;

        of = op_open_file(argv[1], &ret);
        if (of == NULL) {
          fprintf(stderr, "Failed to open file '%s': %i\\n", argv[1], ret);
          return EXIT_FAILURE;
        }
        op_free(of);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["opus"].include}/opus",
                             "-L#{lib}",
                             "-lopusfile",
                             "-o", "test"
    resource("music_48kbps.opus").stage testpath
    system "./test", "music_48kbps.opus"
  end
end
