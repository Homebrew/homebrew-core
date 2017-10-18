class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "http://www.digip.org/jansson/"
  url "http://www.digip.org/jansson/releases/jansson-2.10.tar.gz"
  sha256 "78215ad1e277b42681404c1d66870097a50eb084be9d771b1d15576575cf6447"

  bottle do
    cellar :any
    sha256 "7a6bda990b3750ad5cc78dbc371a14ed13d2c4d713ce596bb54170c3a866b931" => :high_sierra
    sha256 "701c9253fb60487c94b4840a57621d5faf6ad1a8d0659ae6a419e57b5bd94ced" => :sierra
    sha256 "a51789b3b30f9e70232f9e872b08b5367caa5d027f7a8a72ed92c2ef68c432b7" => :el_capitan
    sha256 "4fabfb2143c27b4460560af12a459180221f097ad69ed95e86cf082b436d4950" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
