class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "https://digip.org/jansson/"
  url "https://github.com/akheron/jansson/releases/download/v2.14/jansson-2.14.tar.gz"
  sha256 "5798d010e41cf8d76b66236cfb2f2543c8d082181d16bc3085ab49538d4b9929"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f8a132e116364ead3e428b1ad39768791f7a11ad26c07f5040c41d3514b7dea2"
    sha256 cellar: :any,                 arm64_big_sur:  "08a95c23eb5aa8cfe0af9dc360b4bb3ecab89cfb42db9d5e68bc6490b571321c"
    sha256 cellar: :any,                 monterey:       "b17770854e930d4302809dd4549142205f99a153a231492a9740f0c18d8e3258"
    sha256 cellar: :any,                 big_sur:        "bb129dc922c0610c35a7b161429033a9123f03c4171df35717ff086b9cb52922"
    sha256 cellar: :any,                 catalina:       "ddf25d83863396b864697529e837b869220ce86b8bb7b2cc03b77bdf1129563c"
    sha256 cellar: :any,                 mojave:         "e219fa24f9fa034654592f6626c4a09d01fdeb888343a259a08ab4b1d08ac4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f29060c36272b9dd76c5215e4118c04c0ef9235565281f87c34f8e8029cc3cb"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <jansson.h>
      #include <assert.h>

      int main()
      {
        json_t *json;
        json_error_t error;
        json = json_loads("\\"foo\\"", JSON_DECODE_ANY, &error);
        assert(json && json_is_string(json));
        json_decref(json);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ljansson", "-o", "test"
    system "./test"
  end
end
