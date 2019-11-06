class Libopusenc < Formula
  desc "Convenience libraray for creating .opus files"
  homepage "https://opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/libopusenc-0.2.1.tar.gz"
  sha256 "8298db61a8d3d63e41c1a80705baa8ce9ff3f50452ea7ec1c19a564fe106cbb9"

  bottle do
    cellar :any
    sha256 "7a59056497c0d0fafecb5eba8aa72b6e95bca4535c054da33bcfad57799f6d29" => :catalina
    sha256 "a44552641cccda9fe5068838fb6177a397384c626c1e4fc420b28bfa1161ea92" => :mojave
    sha256 "56a5aad7c5af4f705864cffbb5f5cef59c576299dff0ae4529f3bd9a61aac82f" => :high_sierra
    sha256 "82360661e53da4371b99fb7779aef23993ede434679c2d0c9d6bf1e4fe1978d6" => :sierra
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
