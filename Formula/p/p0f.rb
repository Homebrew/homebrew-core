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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 arm64_tahoe:    "cdd36b28e785533aadfafbd8067b7f6370894b1e709aeb22824efc7247716349"
    sha256 arm64_sequoia:  "26d47c74e8e4c5b3c8463acf5759301a71513c8421e00d88b79fd6acc1510f3a"
    sha256 arm64_sonoma:   "01187398fc42a36aabac534edad37e933c4f9a5731f2c1d7eb2c1d90a6745236"
    sha256 arm64_ventura:  "8a29bf28d9c094a0cf189897703653246509a2c5af95e949c910d98837d48687"
    sha256 arm64_monterey: "ef6f6ea7ee52b7abc9bca1c816b53b81e1449cb4eacd27f2789c39bfb0ef74a8"
    sha256 arm64_big_sur:  "eb601352fdce0ac1b49dfbaa31f91f102768aad81ea907839cd424836edc541b"
    sha256 sonoma:         "c4fba5904bdf5abf0a304bbb5cc86a4d7075251f61b7b75e5d6daa11be8fb2fc"
    sha256 ventura:        "648f67e2bd6d531bcd310bd22966573f7d725f134b75f7bb1504a682981648a9"
    sha256 monterey:       "2d2addb10494350f34a5bf1125bd88e83d8245def1d90ebb1286b469e944880e"
    sha256 big_sur:        "1e5a460d94d43563f06e9eff624e8ec6bba232de496320fb6dd281333b06f045"
    sha256 arm64_linux:    "65866253e2c2d2cb04dd3cbaa0b7a9261a3172872c3a557afbbc61f157ee9ed8"
    sha256 x86_64_linux:   "ed27c8135434e63b76d61034be7a15ed48311ae6d8e146177552ad23786c03af"
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
