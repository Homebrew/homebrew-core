class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.25.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.25.tar.gz"
  sha256 "8b6d4a75122984350186250aaa6063665bfa69100253fd77b972d2744e07dc08"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cb2c2d3fc7800cdea12f6be7ed16caba9a4c7c19ab88e3e63a5c1918997f574d" => :catalina
    sha256 "6fdc5e5b10131648eeeadd8a76ceb81b6f06a0a7b8918fffae500b0d0b41d0ad" => :mojave
    sha256 "753dd7f093256f2e8e0a609e9196f1365953e68661aeb4849441aef6c1b168da" => :high_sierra
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

