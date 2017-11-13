class Libopusenc < Formula
  desc "Convenience libraray for creating .opus files"
  homepage "https://opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/libopusenc-0.1.1.tar.gz"
  sha256 "02e6e0b14cbbe0569d948a46420f9c9a81d93bba32dc576a4007cbf96da68ef3"

  bottle do
    cellar :any
    sha256 "cbbdf62623c8187814e2a96ab3f990c6b5b484aa994fd4909fe2d402405d464f" => :high_sierra
    sha256 "d4ca5b8cda0c64259a461f7a5102412122c14c32c4b7f33eb31279dcfd96f895" => :sierra
    sha256 "53b36128d06e78d72fcb9f2e40be1186b16f847bd38a1ded13cc37bb89fcb763" => :el_capitan
    sha256 "73ee617767aa5fd6bc62d35f38883bc7eb099ba7d5a88369c428dbd585726ec0" => :yosemite
  end

  head do
    url "https://git.xiph.org/libopusenc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "opus"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <opusenc.h>
      #include <assert.h>
      #include <stdint.h>
      #include <stdlib.h>
      int main() {
        OggOpusComments *comments = ope_comments_create();
        assert(comments);
        ope_comments_add(comments, "ARTIST", "Homebrew");
        ope_comments_add(comments, "TITLE", "Test Track");

        int error;
        OggOpusEnc *enc = ope_encoder_create_file("test.opus",
          comments, 48000, 2, 0, &error);;
        assert(error == OPE_OK);
        assert(enc);
        ope_comments_destroy(comments);

        int16_t *buffer = calloc(1920, 2*sizeof(*buffer));
        error = ope_encoder_write(enc, buffer, 1920*2*sizeof(*buffer));
        assert(error == OPE_OK);

        error = ope_encoder_drain(enc);
        assert(error == OPE_OK);
        ope_encoder_destroy(enc);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-Wall",
                   "-I#{Formula["opus"].opt_include}/opus",
                   "-I#{include}/opus",
                   "-L#{lib}", "-lopusenc"
    system "./test"
  end
end
