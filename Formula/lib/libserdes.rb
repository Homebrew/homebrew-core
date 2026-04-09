class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.2.0",
      revision: "8cf97f7395bf5131d14bacfe896c6a5731b1f0c8"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a8a6ac18fe9e1283d6594b9fa6de00094e0b1bb72cbc6c57531efd26d8455d7"
    sha256 cellar: :any,                 arm64_sequoia: "57947297d95bf856cea669a33ae3803b105985aec8f9d3541d2783107a215894"
    sha256 cellar: :any,                 arm64_sonoma:  "4ff52c5e9d42bd93f00857fc623dcc6c6b3644cd6d705642945f77cbf7796fbb"
    sha256 cellar: :any,                 sonoma:        "eb7ef3b627746d980c8c5caed03aa7b8dfe477dff8d4b5378c18002569927cd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78d3628f38a8f91f76c9456939ed8679dc2ed60e2688ebad62cb44db4a83f3cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ff40de94f782acf63e96f3187c9069f0c5009fc4d7a6bc99d17c2370687b07"
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
