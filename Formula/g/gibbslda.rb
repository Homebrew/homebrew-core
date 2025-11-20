class Gibbslda < Formula
  desc "Library wrapping imlib2's context API"
  homepage "https://gibbslda.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gibbslda/GibbsLDA%2B%2B/0.2/GibbsLDA%2B%2B-0.2.tar.gz"
  sha256 "4ca7b51bd2f098534f2fdf82c3f861f5d8bf92e29a6b7fbdc50c3c2baeb070ae"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "16474e9a022ecbe4d80701a9d8c87952298af65fa230430a84be3e3dd6a1cc60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b1a77a02b5d60541a94bc2ed69fb92cfc65c18094ec8973fdcec6eef42e7a7d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4671894574c3037f3da88cce3a3327bf1448bb0e07eee695367a819b9c80447d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6495fc8734f25a5e3a40658a5dd0b4683ad3014bc1943dc0aa2fc2845e61a4ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61e1f465b8ebfe185fcd5b335723cca3ec6ccfb5bb7fe2c411e91c22c0277501"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ef52ad690cdbeaaf7b4a148dc97b730585f491335aae782c2d1fbda0149e868"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd693de81f93ba6758cd14c39af74de1bd77a7e4f5a7767b21f686315aaac4f4"
    sha256 cellar: :any_skip_relocation, ventura:        "7b142fad1e04fe47487d8c5b446bf096baf6277c4567c56898d62322fad3a7d8"
    sha256 cellar: :any_skip_relocation, monterey:       "6be2191e470aa1530264d2af8c872f2324de2e7fecaf225385edcccffa27eb6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e088fd9bf4de22483a82b36f48fbe0f2ea8ecb16e08f2fb2cbfd6a68e0dc274"
    sha256 cellar: :any_skip_relocation, catalina:       "1531c6a6f324f3639ad798d9ae63b461812aecf0a0f3e5a4ad3ea786997c1e5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "17faba95a1fb48b7e0a8989b01fae56959a8cbeabbb64ccdae297e3e8888df1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a30b74269c34fa81e23d50d036a12d3788a8de0dbbe985e1c1efbb66ea54b8a"
  end

  # Build fails without including stdlib - https://trac.macports.org/ticket/41915
  # https://sourceforge.net/p/gibbslda/bugs/4/
  # Also fix build failure because of missing #include <stdio.h> on Linux.
  # Linux patch submitted to SourceForge page:
  # https://sourceforge.net/p/gibbslda/bugs/5/
  patch :DATA

  def install
    system "make", "clean"
    system "make", "all"
    bin.install "src/lda"
    share.install "docs/GibbsLDA++Manual.pdf"
  end
end

__END__
diff --git a/src/utils.cpp b/src/utils.cpp
index e2f538b..1df5fb3 100644
--- a/src/utils.cpp
+++ b/src/utils.cpp
@@ -22,6 +22,7 @@
  */

 #include <stdio.h>
+#include <stdlib.h>
 #include <string>
 #include <map>
 #include "strtokenizer.h"
diff --git a/src/lda.cpp b/src/lda.cpp
index 273d469..4b03d85 100644
--- a/src/lda.cpp
+++ b/src/lda.cpp
@@ -21,6 +21,8 @@
  * Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
  */
 
+#include <stdio.h>
+
 #include "model.h"
 
 using namespace std;
