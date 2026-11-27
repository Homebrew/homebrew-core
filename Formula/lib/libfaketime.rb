class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "https://github.com/wolfcw/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/refs/tags/v0.9.14.tar.gz"
  sha256 "d6468957b11bae8e541524ad43f2cdf91e5d87c8996183897c0499856024c90c"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/wolfcw/libfaketime.git", branch: "master"

  bottle do
    manifest_sha256 "e407f53abd93ef5b922178e968b2ececf92fb2277781a3d4b5eea90960b461dd"
    sha256 arm64_golden_gate: "5099088aa0fa21415d6e01dc084942228569ae86434fcea3ef67cee7d0417890"
    sha256 arm64_tahoe:       "5873cd6861d0ad3fa2c5b77946199bfac2edb99babbc47c9f22b75addaf4cc62"
    sha256 arm64_sequoia:     "73b9207340dd1b828672162156941c9d8534822c91ef2ab4084e63a567a276f7"
    sha256 arm64_linux:       "ad724607aa12e0572bc0b4bfc045ebc01159ce833d879f098c3acdbe66c5468e"
    sha256 x86_64_linux:      "7a418a5de6dfd0dcc3e1a869a321ba6c875b9d197e442003331b6309fe38b26c"
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
index 654fa35..00d50e8 100644
--- a/src/Makefile.OSX
+++ b/src/Makefile.OSX
@@ -80,10 +80,7 @@ all: ${LIBS} ${BINS}
 
 ifeq ($(ARCH),arm64)
 libfaketime.${SONAME}.dylib: libfaketime.c ft_sem.c
-	${CC} -o libfaketime.arm64e.dylib ${CFLAGS} -arch arm64e -fptrauth-calls -fptrauth-returns ${LDFLAGS} ${LIB_LDFLAGS} -install_name ${PREFIX}/lib/faketime/$@ libfaketime.c ft_sem.c
-	${CC} -o libfaketime.arm64.dylib ${CFLAGS} -arch arm64 ${LDFLAGS} ${LIB_LDFLAGS} -install_name ${PREFIX}/lib/faketime/$@ libfaketime.c ft_sem.c
-	lipo -create -output $@ libfaketime.arm64e.dylib libfaketime.arm64.dylib
-	rm libfaketime.arm64e.dylib libfaketime.arm64.dylib
+	${CC} -o $@ ${CFLAGS} -arch arm64 ${LDFLAGS} ${LIB_LDFLAGS} -install_name ${PREFIX}/lib/faketime/$@ libfaketime.c ft_sem.c
 
 faketime: faketime.c ft_sem.c
 	${CC} -o $@ ${CFLAGS} -arch arm64e -arch arm64 ${LDFLAGS} faketime.c ft_sem.c
