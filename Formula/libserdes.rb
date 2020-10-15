class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
    tag:      "v5.5.1",
    revision: "b259d15f68dce65591700b0ccccb73311db1de3d"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git"

  bottle do
    cellar :any
    sha256 "18387cd0d55c022000b92478f68edd90904ad4bf1684862f4eab189dcf90ae48" => :catalina
    sha256 "c61903729be4087a5cad61418cc2a557591d0c457dddc8264d5000d8be03884b" => :mojave
    sha256 "8b89ec94a1e8c571ddf2a9a71f25029c0f6524ad3aa425c2f65afee0869de250" => :high_sierra
  end

  depends_on "avro-c"
  depends_on "jansson"

  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <err.h>
      #include <stddef.h>
      #include <sys/types.h>
      #include <libserdes/serdes.h>

      int main()
      {
        char errstr[512];
        serdes_conf_t *sconf = serdes_conf_new(NULL, 0, NULL);
        serdes_t *serdes = serdes_new(sconf, errstr, sizeof(errstr));
        if (serdes == NULL) {
          errx(1, "constructing serdes: %s", errstr);
        }
        serdes_destroy(serdes);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lserdes", "-o", "test"
    system "./test"
  end
end
