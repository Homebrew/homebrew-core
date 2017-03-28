class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.8.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.8.0.tar.bz2"
  sha256 "596097257c2ce22e747741f8ff3d7e24f6e26231fa198a41b2a072e62d1e5d33"

  bottle do
    cellar :any
    sha256 "0b4a59398bd222620a4d837d7e33ca3141dddd14886c68bccca15a177bda93c7" => :sierra
    sha256 "9764f539b4b51161127d95687c5611f9571ae2abde1dce66ba014a0f33d2bcc1" => :el_capitan
    sha256 "4a4c3e90175b02ded974a8a385b6d9799bcc2873c5a1087c558f350eb103934d" => :yosemite
  end

  patch :DATA

  depends_on "gnupg2"
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "pth"

  def install
    # Check these inreplaces with each release.
    # At some point GnuPG will pull the trigger on moving to GPG2 by default.
    inreplace "src/gpgme-config.in" do |s|
      s.gsub! "@GPG@", "#{Formula["gnupg2"].opt_prefix}/bin/gpg"
      s.gsub! "@GPGSM@", "#{Formula["gnupg2"].opt_prefix}/bin/gpgsm"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    output = shell_output("#{bin}/gpgme-config --get-gpg").strip
    assert_equal "#{Formula["gnupg2"].opt_prefix}/bin/gpg", output
  end
end

__END__
diff --git a/lang/cpp/src/decryptionresult.cpp b/lang/cpp/src/decryptionresult.cpp
--- a/lang/cpp/src/decryptionresult.cpp	2016-10-18 13:22:02.000000000 -0400
+++ b/lang/cpp/src/decryptionresult.cpp	2017-02-06 15:33:38.000000000 -0500
@@ -20,10 +20,6 @@
   Boston, MA 02110-1301, USA.
 */
 
-#ifdef HAVE_CONFIG_H
- #include "config.h"
-#endif
-
 #include <decryptionresult.h>
 #include "result_p.h"
 #include "util.h"
diff --git a/lang/cpp/src/encryptionresult.cpp b/lang/cpp/src/encryptionresult.cpp
--- a/lang/cpp/src/encryptionresult.cpp	2016-10-18 13:22:02.000000000 -0400
+++ b/lang/cpp/src/encryptionresult.cpp	2017-02-06 15:34:30.000000000 -0500
@@ -20,10 +20,6 @@
   Boston, MA 02110-1301, USA.
 */
 
-#ifdef HAVE_CONFIG_H
- #include "config.h"
-#endif
-
 #include <encryptionresult.h>
 #include "result_p.h"
 #include "util.h"
diff --git a/lang/cpp/src/importresult.cpp b/lang/cpp/src/importresult.cpp
--- a/lang/cpp/src/importresult.cpp	2016-10-18 13:22:02.000000000 -0400
+++ b/lang/cpp/src/importresult.cpp	2017-02-06 15:32:54.000000000 -0500
@@ -20,11 +20,6 @@
   Boston, MA 02110-1301, USA.
 */
 
-
-#ifdef HAVE_CONFIG_H
- #include "config.h"
-#endif
-
 #include <importresult.h>
 #include "result_p.h"
 
diff --git a/lang/cpp/src/keygenerationresult.cpp b/lang/cpp/src/keygenerationresult.cpp
--- a/lang/cpp/src/keygenerationresult.cpp	2016-10-18 13:22:02.000000000 -0400
+++ b/lang/cpp/src/keygenerationresult.cpp	2017-02-06 15:33:17.000000000 -0500
@@ -20,10 +20,6 @@
   Boston, MA 02110-1301, USA.
 */
 
-#ifdef HAVE_CONFIG_H
- #include "config.h"
-#endif
-
 #include <keygenerationresult.h>
 #include "result_p.h"
 
diff --git a/lang/cpp/src/signingresult.cpp b/lang/cpp/src/signingresult.cpp
--- a/lang/cpp/src/signingresult.cpp	2016-10-18 13:22:02.000000000 -0400
+++ b/lang/cpp/src/signingresult.cpp	2017-02-06 15:34:14.000000000 -0500
@@ -20,10 +20,6 @@
   Boston, MA 02110-1301, USA.
 */
 
-#ifdef HAVE_CONFIG_H
- #include "config.h"
-#endif
-
 #include <signingresult.h>
 #include "result_p.h"
 #include "util.h"
diff --git a/lang/cpp/src/swdbresult.cpp b/lang/cpp/src/swdbresult.cpp
--- a/lang/cpp/src/swdbresult.cpp	2016-11-09 02:34:15.000000000 -0500
+++ b/lang/cpp/src/swdbresult.cpp	2017-02-06 15:35:39.000000000 -0500
@@ -19,10 +19,6 @@
   Boston, MA 02110-1301, USA.
 */
 
-#ifdef HAVE_CONFIG_H
- #include "config.h"
-#endif
-
 #include "swdbresult.h"
 
 #include <istream>
diff --git a/lang/cpp/src/tofuinfo.cpp b/lang/cpp/src/tofuinfo.cpp
--- a/lang/cpp/src/tofuinfo.cpp	2016-10-18 13:22:02.000000000 -0400
+++ b/lang/cpp/src/tofuinfo.cpp	2017-02-06 15:35:20.000000000 -0500
@@ -19,10 +19,6 @@
   Boston, MA 02110-1301, USA.
 */
 
-#ifdef HAVE_CONFIG_H
- #include "config.h"
-#endif
-
 #include "tofuinfo.h"
 
 #include <istream>
diff --git a/lang/cpp/src/verificationresult.cpp b/lang/cpp/src/verificationresult.cpp
--- a/lang/cpp/src/verificationresult.cpp	2016-10-18 13:22:02.000000000 -0400
+++ b/lang/cpp/src/verificationresult.cpp	2017-02-06 15:33:57.000000000 -0500
@@ -20,10 +20,6 @@
   Boston, MA 02110-1301, USA.
 */
 
-#ifdef HAVE_CONFIG_H
- #include "config.h"
-#endif
-
 #include <verificationresult.h>
 #include <notation.h>
 #include "result_p.h"
diff --git a/lang/cpp/src/vfsmountresult.cpp b/lang/cpp/src/vfsmountresult.cpp
--- a/lang/cpp/src/vfsmountresult.cpp	2016-10-18 13:22:02.000000000 -0400
+++ b/lang/cpp/src/vfsmountresult.cpp	2017-02-06 15:34:57.000000000 -0500
@@ -21,10 +21,6 @@
   Boston, MA 02110-1301, USA.
 */
 
-#ifdef HAVE_CONFIG_H
- #include "config.h"
-#endif
-
 #include <vfsmountresult.h>
 #include "result_p.h"
 
