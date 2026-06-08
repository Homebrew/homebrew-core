class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.2.1",
      revision: "8cf97f7395bf5131d14bacfe896c6a5731b1f0c8"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a877cd15be330998154ad994e0c472f692afc3a02617495e8e335b4eedd0eb6d"
    sha256 cellar: :any,                 arm64_sequoia: "2b8a989cb06c593ced0e262bdf4ea22f974158277987b531f4b4742b5f2bbd9d"
    sha256 cellar: :any,                 arm64_sonoma:  "edaa2e34bd879ee11f0506f5ae6b2d49861050f5f251e24f52b6061f46d5e008"
    sha256 cellar: :any,                 sonoma:        "c84b18a3ad9499ae3ec291b8d8a38caad25bf8fea29e453a10890606637498dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "454f61c3c4eb631dec6454de7b782de8b6bf3f628a3c58f96e10add5a0e4fa14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1499b281524c46e0bd15bbb87dbb202e4b80f0ef76a2ad19602380bf6bf2da2c"
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
