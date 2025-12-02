class Duktape < Formula
  desc "Embeddable Javascript engine with compact footprint"
  homepage "https://duktape.org"
  url "https://github.com/svaarala/duktape/releases/download/v2.7.0/duktape-2.7.0.tar.xz"
  sha256 "90f8d2fa8b5567c6899830ddef2c03f3c27960b11aca222fa17aa7ac613c2890"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5fe1dd30da74b054c84215502091d01461ee22644b32f278cb883bf8e65d71f7"
    sha256 cellar: :any,                 arm64_sequoia:  "3d744482873a3e4aee3ba9a4471a7d75c1065519466e1730169b2d47a6ef8a18"
    sha256 cellar: :any,                 arm64_sonoma:   "8afe806970354b4fafeb1e390d3823964c2fe969d5ae9498612a1c0422cea24f"
    sha256 cellar: :any,                 arm64_ventura:  "cb5c28b480f4948b1c058146568829a0a31a082ee5646af9f1c9d163f8fea00a"
    sha256 cellar: :any,                 arm64_monterey: "50433844eb30fed82c204f4ad5b0fe58f70f6ab3fdcaf88f58df1080cc65d3cd"
    sha256 cellar: :any,                 arm64_big_sur:  "37641156c20de01c3fe4a5f2df5a16cf2d5ff3f64376a63969643c463ed35e02"
    sha256 cellar: :any,                 sonoma:         "dbf3ef6af3565f4a08abdcc243ac18214ae37000b3cb3d4704b807b32cc8040d"
    sha256 cellar: :any,                 ventura:        "1c4196f4cfb1ba4319714b7d31249e89cce27ed41ff82bf10ae90e10be159b21"
    sha256 cellar: :any,                 monterey:       "1da51e2ceb61766abe0074b869c482feb2b61cffbd9419ceb70157191528f703"
    sha256 cellar: :any,                 big_sur:        "89c9cbfd84d99f2cc97f1cd8a4e57f18c3aa3803be295328a8b67239ae51ed27"
    sha256 cellar: :any,                 catalina:       "b4dbf4083450e750f2ddfa26d4f4bca18a342703ef950360528e4c390d171636"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6bf806c110978a59312df80334012c02e8a285b364effe90c1aea33370549d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "158b015f9c3b091605deed158af5f37c816c48d00b1163402282459298fd921e"
  end

  def install
    ENV["INSTALL_PREFIX"] = prefix
    system "make", "-f", "Makefile.sharedlibrary", "install"
    system "make", "-f", "Makefile.cmdline"
    bin.install "duk"
  end

  test do
    (testpath/"test.js").write "console.log('Hello Homebrew!');"
    assert_equal "Hello Homebrew!", shell_output("#{bin}/duk test.js").strip

    (testpath/"test.cc").write <<~CPP
      #include <stdio.h>
      #include "duktape.h"

      int main(int argc, char *argv[]) {
        duk_context *ctx = duk_create_heap_default();
        duk_eval_string(ctx, "1 + 2");
        printf("1 + 2 = %d\\n", (int) duk_get_int(ctx, -1));
        duk_destroy_heap(ctx);
        return 0;
      }
    CPP
    system ENV.cc, "test.cc", "-o", "test", "-I#{include}", "-L#{lib}", "-lduktape", "-lm"
    assert_equal "1 + 2 = 3", shell_output("./test").strip, "Duktape can add number"
  end
end
