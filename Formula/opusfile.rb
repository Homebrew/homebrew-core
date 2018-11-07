class Opusfile < Formula
  desc "API for decoding and seeking in .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opusfile-0.11.tar.gz"
  sha256 "74ce9b6cf4da103133e7b5c95df810ceb7195471e1162ed57af415fabf5603bf"

  bottle do
    cellar :any
    sha256 "0fa06c4b8d2d0d5b4b26f359de9d31070e80aedf46617200bad238f10adc3d17" => :mojave
    sha256 "f71e02c57dc80bbe54d87113dd229aefbbecbd349e371d43a513a40222066fc4" => :high_sierra
    sha256 "51ab7cca1cb376114f385070b12bba44621d993786323d493bd6643304a6fb93" => :sierra
    sha256 "63efbc0d92409dbe3fd5e222639a92df0bb54322f62b90d002267ddd2be97b8c" => :el_capitan
  end

  head do
    url "https://git.xiph.org/opusfile.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "openssl"
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
