class Duktape < Formula
  desc "Embeddable Javascript engine with compact footprint"
  homepage "https://duktape.org"
  url "https://github.com/svaarala/duktape/releases/download/v2.6.0/duktape-2.6.0.tar.xz"
  sha256 "96f4a05a6c84590e53b18c59bb776aaba80a205afbbd92b82be609ba7fe75fa7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "a433cc772fa217fdfc55adf56a0080eb6da1b8ff9434336318d20b924f36f0a3" => :big_sur
    sha256 "c0557537b880f90bc30637561d9e749c0405c215afb951733da3368db82deb4e" => :arm64_big_sur
    sha256 "3abfb4891e9d485ed2e20ba42074a82a254f714ca646b1285cb08ce3cc56d23f" => :catalina
    sha256 "6eb347fe58ee46c3b915e81daae45fb3ebcb5f6a822482b5d4aa2f84df39481b" => :mojave
    sha256 "d2a496ae5d023333d5b904f8b92869e6bfa855b101c5313ed39f1f180eaf8833" => :high_sierra
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
