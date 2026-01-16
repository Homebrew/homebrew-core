class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.1.1",
      revision: "8cf97f7395bf5131d14bacfe896c6a5731b1f0c8"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "17e4b3183c2645cd900aaa0ef92577b3fc0a179542bc8c12d267557e8d9d6386"
    sha256 cellar: :any,                 arm64_sequoia: "87c958cad7c5f9d3163f300b8f01db524ae0d8515e1ead19832b993a4c69d197"
    sha256 cellar: :any,                 arm64_sonoma:  "65c19c915e0f413d912ea66857f7ca1179650eb37a5226250ce7753400edc721"
    sha256 cellar: :any,                 sonoma:        "67b3a06b0d5957be17227ed43148273be414ff42494283220f2288236aa230b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b5b0d5f7fc14037166fbb20aaf84e522edf218abf0f0783f338c2341d2c88e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e228417bd038ecc414a6e3178fe3763241f5ee5be8722f6796116deb17943b6"
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
