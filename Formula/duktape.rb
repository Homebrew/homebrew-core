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
    sha256 cellar: :any,                 arm64_monterey: "05e6bd04eadb5a45c3bd2d388ee9bfc573d05b7cd9d05fccb00978cc111302ac"
    sha256 cellar: :any,                 arm64_big_sur:  "c0557537b880f90bc30637561d9e749c0405c215afb951733da3368db82deb4e"
    sha256 cellar: :any,                 monterey:       "cce62a7fa64b656597293f0a22ee28ddb37fa62b8ced9bdce55e946874b008ef"
    sha256 cellar: :any,                 big_sur:        "a433cc772fa217fdfc55adf56a0080eb6da1b8ff9434336318d20b924f36f0a3"
    sha256 cellar: :any,                 catalina:       "3abfb4891e9d485ed2e20ba42074a82a254f714ca646b1285cb08ce3cc56d23f"
    sha256 cellar: :any,                 mojave:         "6eb347fe58ee46c3b915e81daae45fb3ebcb5f6a822482b5d4aa2f84df39481b"
    sha256 cellar: :any,                 high_sierra:    "d2a496ae5d023333d5b904f8b92869e6bfa855b101c5313ed39f1f180eaf8833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8b9146489dc275a3a0e94286acd45b22ef1cc4355b7e94f46f030a973b4e038"
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
    system ENV.cc, "test.cc", "-o", "test", "-I#{include}", "-L#{lib}", "-lduktape", "-lm"
    assert_equal "1 + 2 = 3", shell_output("./test").strip, "Duktape can add number"
  end
end
