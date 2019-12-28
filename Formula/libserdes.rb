class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
  :tag      => "v5.3.1",
  :revision => "b259d15f68dce65591700b0ccccb73311db1de3d"

  bottle do
    cellar :any
    sha256 "dead031073dab8aaef737aa375f1680292ce255831490b81fa27144541e6c5ed" => :catalina
    sha256 "a4b50f80108a872399113d393e6b51815489ae435f5c1ae50ae3fbb98cd2b438" => :mojave
    sha256 "366a4c92119d186c66c4a6366b45da2bc307084d3d183809238dcd0654e9d8d2" => :high_sierra
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
