class Opusfile < Formula
  desc "API for decoding and seeking in .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opusfile-0.9.tar.gz"
  sha256 "f75fb500e40b122775ac1a71ad80c4477698842a8fe9da4a1b4a1a9f16e4e979"

  bottle do
    cellar :any
    sha256 "60977347332d650de34fead40a69312d3eac3b00d8d7756726bef751bc9b4ca9" => :sierra
    sha256 "dc95a08834e93a459f47c0dc4114542b038a79d266c4722da27365879901b71a" => :el_capitan
    sha256 "f04e162a07dff00edb780fb3eed26084b7416debb33c13061d8d84d84d47fefc" => :yosemite
    sha256 "a44a9b6a34eae4f1a0c6c3b3c0fd1bae2e2c7893376e3b345d5498eee30a8622" => :mavericks
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
    (testpath/"test.c").write <<-EOS.undent
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
