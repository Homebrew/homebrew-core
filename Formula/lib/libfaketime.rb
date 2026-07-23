class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "https://github.com/wolfcw/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/refs/tags/v0.9.12.tar.gz"
  sha256 "4fc32218697c052adcdc5ee395581f2554ca56d086ac817ced2be0d6f1f8a9fa"
  license "GPL-2.0-only"
  head "https://github.com/wolfcw/libfaketime.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "bcd23642919c6bacca9c7d75e1c473fdf1f86f5e748503f089fe9324eac7c369"
    sha256 arm64_sequoia: "c030c10a9d07fc14da42e60bcc11d8a376439b7bffd59e419bbb76abd82727f9"
    sha256 arm64_sonoma:  "6e77335420fdca3480dbe4a8d8c208700d098986d2a1919b090d18e894ee1f68"
    sha256 arm64_ventura: "ce35c8e69155c44bb30e3966ad6f61d4f8b6e6d4d75205f9d243cf1fea4b92f1"
    sha256 sonoma:        "73638e62bae905cfe0e2484f8c8a0a01ad064cdd68c5c55b8708a2ee8ebe9720"
    sha256 ventura:       "fb1d11b731aaf10df060a0a3b1376f55cd1e37924494ff20732bd62db0a3ff7d"
    sha256 arm64_linux:   "600785347f8e59a106e286b38c4fd82a2ba422be0fd6d453baf8d71179f56da4"
    sha256 x86_64_linux:  "feb25281dd8aec835459b0381734f5a2cd877738c23da58d636d2b7d95bc9a0f"
  end

  on_macos do
    # The `faketime` command needs GNU `gdate` not BSD `date`.
    # See https://github.com/wolfcw/libfaketime/issues/158 and
    # https://github.com/Homebrew/homebrew-core/issues/26568
    depends_on "coreutils"
  end

  # upstream bug report, https://github.com/wolfcw/libfaketime/issues/506
  patch :DATA

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <time.h>

      int main(void) {
        printf("%d\\n",(int)time(NULL));
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test"
    assert_match "1230106542", shell_output("TZ=UTC #{bin}/faketime -f '2008-12-24 08:15:42' ./test").strip
  end
end

__END__
diff --git a/src/Makefile.OSX b/src/Makefile.OSX
index 405c021..dae9880 100644
--- a/src/Makefile.OSX
+++ b/src/Makefile.OSX
@@ -72,8 +72,7 @@ LIB_LDFLAGS += -dynamiclib -current_version 0.9.12 -compatibility_version 0.7
 ARCH := $(shell uname -m)

 ifeq ($(ARCH),arm64)
-    CFLAGS += -arch arm64e -arch arm64
-    CFLAGS += -fptrauth-calls -fptrauth-returns
+    CFLAGS += -arch arm64
 endif

 SONAME = 1
