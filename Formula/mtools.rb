class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.26.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.26.tar.gz"
  sha256 "b1adb6973d52b3b70b16047e682f96ef1b669d6b16894c9056a55f407e71cd0f"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e79ddc6fe5d42ee6254d92868da71fefc84b3c65130ee84304f9cc73ae119b4f" => :big_sur
    sha256 "c03be273031ac22f8d407cbd903ba2913c81f058ad72d23f392289d3c7f9d7f6" => :catalina
    sha256 "7d5f50dd790784f12c447570d9f905646cb92cfb7ce88bc0dea32386e26ed6a3" => :mojave
  end

  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  # 4.0.25 doesn't include the proper osx locale headers.
  patch :DATA

  def install
    args = %W[
      LIBS=-liconv
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/mtools --version")
  end
end

__END__
diff --git a/sysincludes.h b/sysincludes.h
index 056218e..ba3677b 100644
--- a/sysincludes.h
+++ b/sysincludes.h
@@ -279,6 +279,8 @@ extern int errno;
 #include <pwd.h>
 #endif
 
+#include <xlocale.h>
+#include <strings.h>
 
 #ifdef HAVE_STRING_H
 # include <string.h>

