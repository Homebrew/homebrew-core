class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.3.0",
      revision: "8cf97f7395bf5131d14bacfe896c6a5731b1f0c8"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6030b8b4099227ab8d5b85b72ed09a5f12107386488e80574af03db0e8d674b1"
    sha256 cellar: :any, arm64_sequoia: "c98a1ed6db414fb4ff948526c95e73c74400c722d078909bbf2d462da13de29b"
    sha256 cellar: :any, arm64_sonoma:  "15b3a826afc830462f5da883d93bcb86895871adcc90bcc6f05779ef10c26bcb"
    sha256 cellar: :any, sonoma:        "99c1cd985377321d5189b949bd7bb04cad4f37f7d25080f77546cce058b2c96d"
    sha256 cellar: :any, arm64_linux:   "ef2d1f00f7009bcfb0523a95cca94921aa41ad4b17012cd652a01742fbdd7a26"
    sha256 cellar: :any, x86_64_linux:  "c3f65a16f36dc85c0fb850d7c55c134b224d7d43525f32a5b2d378d67c42ab38"
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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lserdes", "-o", "test"
    system "./test"
  end
end
