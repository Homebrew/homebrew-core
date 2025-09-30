class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.0.1",
      revision: "8cf97f7395bf5131d14bacfe896c6a5731b1f0c8"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c14cdfa9ed6f431072d8c34d5b3e17e15626177570e3cb8f0f47748efceeb623"
    sha256 cellar: :any,                 arm64_sequoia: "a361ce1442a89dca8a58be5660f9ce8b3642b7cf41e9fb86e4db2e26e777b5fb"
    sha256 cellar: :any,                 arm64_sonoma:  "2f76ddcfcaccaaa52cf2eee0bfb58adb993d62c18a0748e3803544677cd23628"
    sha256 cellar: :any,                 sonoma:        "be8d9684ec653b78b12ec47758ff3753ec990bbff7c0b8512dd98e87f252ceb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a56e6ecdd23d8e7e734a157fc7323867cadb4c857a0b8cb23ebaa85c16bfcc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed7e4c5687585875bdd1139e219a4a2d567f319d9c8360065be564e62826140c"
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
