class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "https://digip.org/jansson/"
  url "https://digip.org/jansson/releases/jansson-2.13.1.tar.gz"
  sha256 "f4f377da17b10201a60c1108613e78ee15df6b12016b116b6de42209f47a474f"
  license "MIT"

  bottle do
    cellar :any
    sha256 "e6a942f77821fd65810d4bc20e6938364a5e40cd7c8510c4b090731573bd0088" => :catalina
    sha256 "587acdadd1ea8bcf22c316f55a32084f530280a7e24f0864e0e420718d0d1b7f" => :mojave
    sha256 "38085c147eb40d58df8a91a44e7544d4ceb248aa25f54bdd8a3b10c1a214d9e9" => :high_sierra
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
