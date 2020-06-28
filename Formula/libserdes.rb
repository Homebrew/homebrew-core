class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
    :tag      => "v5.5.1",
    :revision => "b259d15f68dce65591700b0ccccb73311db1de3d"
  head "https://github.com/confluentinc/libserdes.git"

  bottle do
    cellar :any
    sha256 "2e2cd2f5eb3707aee7b9c1246af36f289c841440d833a49f3eca808bfffd2df3" => :catalina
    sha256 "5393e6c330a7132965ed5c69da565ebec6e0ac8e197e9f5ea8caa769529ac1c8" => :mojave
    sha256 "1dfefee0f44e89d5279fa21134e8e95612b590ce167a742362c39cc192de4110" => :high_sierra
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
