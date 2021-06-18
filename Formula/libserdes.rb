class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v6.2.0",
      revision: "ed53a422a2ddc70acaa328f6e1b8012ec52d1fb6"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "29cd5069db8ce93a2aae253ad3436046e40ddf0e31cfb713022a0e80a8e0d872"
    sha256 cellar: :any, big_sur:       "ae01cfc3bec7b2ae9778b5701d1e30de2bfa9fd8a9dc64d0a05280ef5bcc7b47"
    sha256 cellar: :any, catalina:      "8845db8f2c79e1f32a41de8a4c2786b986e619b8181b6626355cd31171202ebf"
    sha256 cellar: :any, mojave:        "a771b808d04dab53fe808d430033676cf3adde32e01aad699114db50b504a62c"
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
