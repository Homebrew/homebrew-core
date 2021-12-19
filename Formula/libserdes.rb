class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v7.0.1",
      revision: "8c02e4cd98f0eaf6113fc1fa0b8a0ee9350c4961"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1424e3206b7588beb80933b213e0154c8250ed1f6b9b57f14ef967b55a983f57"
    sha256 cellar: :any,                 arm64_big_sur:  "2e68f2c9e1b7a574107c82b5e9512c37ffbfbe27c569aaafdebc0eb2bca86124"
    sha256 cellar: :any,                 monterey:       "3480af68db7d85e153c2583cf98774c87972924c3fb5faaf6ce7b37027e3ffa8"
    sha256 cellar: :any,                 big_sur:        "fd1f0c1afc009be2eb9244446e649d15e5226425be29ca4d8095157c5b722eb5"
    sha256 cellar: :any,                 catalina:       "8af57d2315fc117a6443236a77ed3c91dde296e8523f7932d122728e5dbc3da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31920199303177f95399259bd3515d102518d618529087aa7c07ace23a718e08"
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
