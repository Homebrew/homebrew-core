class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.3.2",
      revision: "8cf97f7395bf5131d14bacfe896c6a5731b1f0c8"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "52d4f3d2ab0d9343d54ea664fa25f77f37faca6b6b5a684e3239540fe541169c"
    sha256 cellar: :any, arm64_tahoe:       "e40d0e4c0c27928f6ca749ac2abb79ea77f3d9514b10ce2ebfeb7a7700a760d1"
    sha256 cellar: :any, arm64_sequoia:     "e1cbe0384cc49e96a13a20ed4a83f3432a05457ad34c4d6f5f54c65443841220"
    sha256 cellar: :any, arm64_linux:       "18a0335a04e08247a706aa4d31fc7f0b21a7231ec439cd3f37592953d8fa3e12"
    sha256 cellar: :any, x86_64_linux:      "3edf8e5866dd9e8a1777a03b77e6d8f35f13f42f407ea17d9f830c9675c38e2d"
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
