class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v7.0.0",
      revision: "a04cc80dc38aaf4ed7b4c9c60b781ebf4cbfda5e"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c15431602aecdd6cb2e108d7d84e4f7468a17235cdf0289dd619a3cf951251c"
    sha256 cellar: :any,                 arm64_big_sur:  "ae93f71843a6b09dee0ec5921e12ecea336f1dab672509c3780868edd674f2b4"
    sha256 cellar: :any,                 monterey:       "49d5c408b5f11670190146a8aa78db5499d5c84d52ced60df72b21437ce39ffa"
    sha256 cellar: :any,                 big_sur:        "8dc8f1c91e214a86d2d2b9b3c9e093f11f8410327f0834581be528cb31ef0e2f"
    sha256 cellar: :any,                 catalina:       "6e787eee3da70740262d668ba474c849fb060d807f5896fb5fa741f87757c379"
    sha256 cellar: :any,                 mojave:         "bafb84c4afe99d9852283bbc86370294aa973569eb4c85f600f0c8993428de56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3129deb96b23fc8518456f9e1673b36f1cf74e7b55e1f5f7f72fe840573c8331"
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
