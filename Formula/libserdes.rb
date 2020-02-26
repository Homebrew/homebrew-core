class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
    :tag      => "v5.3.1",
    :revision => "b259d15f68dce65591700b0ccccb73311db1de3d"
  head "https://github.com/confluentinc/libserdes.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b67057508abef7929928eeb8971528d72d09a139e6a3c873d27c01b3fd205227" => :catalina
    sha256 "0502e2247ba623241c2955b9a85114a621400b961765fa02135f806ba79c2c77" => :mojave
    sha256 "d8f5c959838343a7368798b33cb741fbdbb8a67afbcb4d2acbc94e5098dc19f6" => :high_sierra
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
