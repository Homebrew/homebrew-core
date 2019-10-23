class Libserdes < Formula
  desc "Avro serialization/deserialization library for C/C++"
  homepage "https://github.com/confluentinc/libserdes"
  url "http://packages.confluent.io/deb/5.3/pool/main/c/confluent-libserdes/confluent-libserdes_5.3.1.orig.tar.gz"
  sha256 "06bcb4066f6f13d2f4ece7987188c1feb9510c36bb5828e3283c267267c3d470"

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
