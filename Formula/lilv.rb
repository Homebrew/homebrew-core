class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.24.14.tar.bz2"
  sha256 "6399dfcbead61a143acef3a38ad078047ab225b00470ad5d33745637341d6406"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bd62a762264f26186af0f369e12e3360a7262094dd3af8f1adce2604b882b19a"
    sha256 cellar: :any,                 arm64_big_sur:  "612ae87c45a4ef670deddf610e6e54f7e0eb80d5c8b227d58cb97716118206c7"
    sha256 cellar: :any,                 monterey:       "fab5a0d28b32609527e4145b16edbd4bc9bc37d8a87eab0d456566024aced21b"
    sha256 cellar: :any,                 big_sur:        "58ee0b0d50d9b3eb24f00beaa1466e6858cfef89226027b0f03ba1f82f5cfa20"
    sha256 cellar: :any,                 catalina:       "3ebca1b8b6e8fa09155a1cbbe2fe451cd061db202d2c574259cc7e042c1c0e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa51df59b201664494b9ecd8f0bcce145cc448bd1fabb1a21d95497e9e9a1a4"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lilv/lilv.h>

      int main(void) {
        LilvWorld* const world = lilv_world_new();
        lilv_world_free(world);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/lilv-0", "-L#{lib}", "-llilv-0", "-o", "test"
    system "./test"

    system Formula["python@3.10"].opt_bin/"python3", "-c", "import lilv"
  end
end
