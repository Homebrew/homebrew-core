class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.3.1",
      revision: "8cf97f7395bf5131d14bacfe896c6a5731b1f0c8"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "651a5dd6c99518a5c7da038c86d8168f63348e670f04ce4f9f7005ee9fcf76c0"
    sha256 cellar: :any, arm64_sequoia: "9b7b597664edf874094560926e8eee4d60bff396bd2b7be3e53b0f4e20edec26"
    sha256 cellar: :any, arm64_sonoma:  "c28d8f521800ad60f2fefed83e23b95fff03664cbb68c00d6bbb4ef8199ace36"
    sha256 cellar: :any, sonoma:        "1f28c549b7b72ab3d45bc8af6b08e23d7dab4bbc31c1946e4085683f5a181c52"
    sha256 cellar: :any, arm64_linux:   "99a68d7b317ae0fad506697212bd3ee53405e803fd83c080c0ff100bff452ec3"
    sha256 cellar: :any, x86_64_linux:  "ca7b515ac063254f58e159f1f6e702e75ec52b85ed49dd6824490d9f0582d021"
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
