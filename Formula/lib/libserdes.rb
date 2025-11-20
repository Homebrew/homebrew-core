class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.1.0",
      revision: "8cf97f7395bf5131d14bacfe896c6a5731b1f0c8"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "05a230a415236cd1e7c1f2726b3b1b83fa46fd32d15de35a9bf705710a4fbdbb"
    sha256 cellar: :any,                 arm64_sequoia: "e05b17fb8a8c067156dfb2d276b305dfbf54db2e2991ad3f9f100797d05453c7"
    sha256 cellar: :any,                 arm64_sonoma:  "65938a9313bbffbe0e939a1b055f87d944350a0242d99f04e650b1d0e45c619f"
    sha256 cellar: :any,                 sonoma:        "7f655e806ce4786d2d847643d1e4e2eb0488f4a78551a1c81029feeb005ba0e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2b778aaa38322770f2f72079120ee7f08d451685685308713c24d8673d4da0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94885143ef876f48a79fb85f51054a6d01fed7f8ff4f6355dff01c73b8cd21a"
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
