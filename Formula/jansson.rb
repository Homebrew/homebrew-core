class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "http://www.digip.org/jansson/"
  url "http://www.digip.org/jansson/releases/jansson-2.12.tar.gz"
  sha256 "5f8dec765048efac5d919aded51b26a32a05397ea207aa769ff6b53c7027d2c9"

  bottle do
    cellar :any
    sha256 "79437c250f1b9fff4eab1a15385bbc38e5a29856b0efe3e5b0d68356d24d1f7b" => :mojave
    sha256 "aeb69f2744314df891be52ee4ff2fdb95e8991715a24f74858535063639f3491" => :high_sierra
    sha256 "ffafd42341f4a86ab91bf46e56a2cc4436d840998a9d053bff38467f8b6f4a1b" => :sierra
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
