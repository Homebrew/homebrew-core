class P0f < Formula
  desc "Versatile passive OS fingerprinting, masquerade detection tool"
  homepage "https://lcamtuf.coredump.cx/p0f3/"
  url "https://lcamtuf.coredump.cx/p0f3/releases/p0f-3.09b.tgz"
  sha256 "543b68638e739be5c3e818c3958c3b124ac0ccb8be62ba274b4241dbdec00e7f"
  license "LGPL-2.1-only"

  livecheck do
    url :homepage
    regex(/href=.*?p0f[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_monterey: "20c57f61e80a48bf98f581db4092d2e02ebf638f9db351c76e572327a0480189"
    sha256 arm64_big_sur:  "c2b5dfb6885142c3066f900623a1cb1e4920335ad80455f49ae463f2bb07e953"
    sha256 monterey:       "2a8347e3475e8d63c23f364073b642a28bc6c41d356b17de6e07f4b17bef24de"
    sha256 big_sur:        "333bc8a70dec845a21858507a78babe80e6c7cd15b1a2f4ea3c4715daeef331f"
    sha256 catalina:       "e92f0c171b9cf2c80436092412916c98391d6fdc9f37ec16ab2243ad4539b288"
    sha256 mojave:         "7c69ba2615e5ac9c84dba65ed8a208c7b3cc8b68d1f11b07ae3c5db17103557d"
    sha256 x86_64_linux:   "d24c287755ee5a370ba3676590241e2ad2bf01ca672aecfa108725a165288d87"
  end

  uses_from_macos "libpcap"

  # Fix Xcode 12 issues with "-Werror,-Wimplicit-function-declaration"
  patch :DATA

  def install
    inreplace "config.h", "p0f.fp", "#{etc}/p0f/p0f.fp"
    system "./build.sh"
    sbin.install "p0f"
    (etc/"p0f").install "p0f.fp"
  end

  test do
    system "#{sbin}/p0f", "-r", test_fixtures("test.pcap")
  end
end

__END__
--- p0f-3.09b/build.sh.ORIG	2020-12-23 03:36:51.000000000 +0000
+++ p0f-3.09b/build.sh	2020-12-23 03:41:54.000000000 +0000
@@ -174,7 +174,7 @@
 
 echo "OK"
 
-echo -n "[*] Checking for *modern* GCC... "
+echo -n "[*] Checking if $CC supports -Wl,-z,relro -pie ... "
 
 rm -f "$TMP" "$TMP.c" "$TMP.log" || exit 1
 
@@ -197,7 +197,7 @@
 
 rm -f "$TMP" "$TMP.c" "$TMP.log" || exit 1
 
-echo -e "#include \"types.h\"\nvolatile u8 tmp[6]; int main() { printf(\"%d\x5cn\", *(u32*)(tmp+1)); return 0; }" >"$TMP.c" || exit 1
+echo -e "#include <stdio.h>\n#include \"types.h\"\nvolatile u8 tmp[6]; int main() { printf(\"%d\x5cn\", *(u32*)(tmp+1)); return 0; }" >"$TMP.c" || exit 1
 $CC $USE_CFLAGS $USE_LDFLAGS "$TMP.c" -o "$TMP" &>"$TMP.log"
 
 if [ ! -x "$TMP" ]; then
