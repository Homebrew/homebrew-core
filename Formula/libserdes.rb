class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
    :tag      => "v5.4.1",
    :revision => "b259d15f68dce65591700b0ccccb73311db1de3d"
  head "https://github.com/confluentinc/libserdes.git"

  bottle do
    cellar :any
    sha256 "b772ad8f9f7bdad9410f9e5ca2f07309b5a29a8cbf759a66b6df39db2aa6296e" => :catalina
    sha256 "914f4ef71712ab8e7fa4dedc6a9791beb880410d5fa016ef2b81fe915b88f74f" => :mojave
    sha256 "dff01f2af31c06b86ab553f5d6d267f343da60fbd21003696fde8e28781e76cd" => :high_sierra
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
