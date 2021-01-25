class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v6.0.0",
      revision: "b259d15f68dce65591700b0ccccb73311db1de3d"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git"

  bottle do
    cellar :any
    sha256 "28d5e55c0e0e06b11a30b03250eca9e615b495f666a78efda0a8794752094519" => :big_sur
    sha256 "a1b0c2b9a7fb677827b9728c508ffc48cdd72d1dbe1f53ac094a7d902e7ca0b3" => :arm64_big_sur
    sha256 "743106f80ee1f57a8fd2966fbfc926dc18b11438ed1d90da7373ada9094d7cff" => :catalina
    sha256 "dc74a2436a72405e5fe1b03c83820e3baaeb3bc6ff7623555e3a352d9d05f822" => :mojave
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
