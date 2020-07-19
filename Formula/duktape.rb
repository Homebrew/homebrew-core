class Duktape < Formula
  desc "Embeddable Javascript engine with compact footprint"
  homepage "https://duktape.org"
  url "https://github.com/svaarala/duktape/releases/download/v2.5.0/duktape-2.5.0.tar.xz"
  sha256 "83d411560a1cd36ea132bd81d8d9885efe9285c6bc6685c4b71e69a0c4329616"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "0f182d03ddebdaa46b3f0991909705ec14402b67d889c64a3ac4c9748fdf8e3d" => :catalina
    sha256 "38eb8d5d6226b4fc3fe26c125a4581f3d542fd61d86f7734220102d75c63e790" => :mojave
    sha256 "96129b54cdf5ef5a43a0c54295b05ea902293fc7c10b5bb8e829db3a57f6850e" => :high_sierra
  end

  def install
    inreplace "Makefile.sharedlibrary", /INSTALL_PREFIX\s*=.*$/, "INSTALL_PREFIX = #{prefix}"
    system "make", "-f", "Makefile.sharedlibrary", "install"
    system "make", "-f", "Makefile.cmdline"
    bin.install "duk"
  end

  test do
    (testpath/"test.js").write "console.log('Hello Homebrew!');"
    assert_equal "Hello Homebrew!", shell_output("#{bin}/duk test.js").strip

    (testpath/"test.cc").write <<~EOS
      #include <stdio.h>
      #include "duktape.h"

      int main(int argc, char *argv[]) {
        duk_context *ctx = duk_create_heap_default();
        duk_eval_string(ctx, "1 + 2");
        printf("1 + 2 = %d\\n", (int) duk_get_int(ctx, -1));
        duk_destroy_heap(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.cc", "-o", "test", "-I#{include}", "-L#{lib}", "-lduktape"
    assert_equal "1 + 2 = 3", shell_output("./test").strip, "Duktape can add number"
  end
end
