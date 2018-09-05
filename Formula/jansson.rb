class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "http://www.digip.org/jansson/"
  url "http://www.digip.org/jansson/releases/jansson-2.11.tar.gz"
  sha256 "6e85f42dabe49a7831dbdd6d30dca8a966956b51a9a50ed534b82afc3fa5b2f4"

  bottle do
    cellar :any
    sha256 "073c0c6625eed1682fa386b2ed235bb2d62f4003060736991c5b81531f7ce319" => :mojave
    sha256 "d25f04f7b7b68d880cb22bfd9f0c2d071419e5e90f7899337a534c4feadffbf4" => :high_sierra
    sha256 "2136b357ac1d0df8ff75e8ff7602cbc390c58908d4394dc1a38fe1be98601347" => :sierra
    sha256 "421a63d722386003c678c7fd18de6114b9a8ffa5d8c0994db5f117e3cb8247ec" => :el_capitan
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
