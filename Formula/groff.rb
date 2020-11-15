class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftp.gnu.org/gnu/groff/groff-1.22.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/groff/groff-1.22.4.tar.gz"
  sha256 "e78e7b4cb7dec310849004fa88847c44701e8d133b5d4c13057d876c1bad0293"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "a7c425eec2e56f10e06978b393c0cf53269d27f20e801856fd6d2ba91df81136" => :catalina
    sha256 "1ee2ce419f4d59f098f0804e1dea42524ef72a88b69ce891c42f13d5f19be5f9" => :mojave
    sha256 "24fac4b672946970b70c6e308311e87a6686fed50d4d0909228afb252531065d" => :high_sierra
    sha256 "2966f4b562c30eb6679d6940b43f4b99b2b625433e6a218489f160eb76c7c360" => :sierra
  end

  # See https://savannah.gnu.org/bugs/index.php?59276
  # Fixed in 1.23.0
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make" # Separate steps required
    system "make", "install"
  end

  test do
    assert_match "homebrew\n",
      pipe_output("#{bin}/groff -a", "homebrew\n")
  end
end
__END__
--- a/src/libs/libgroff/assert.cpp
+++ b/src/libs/libgroff/assert.cpp
@@ -16,6 +16,10 @@ for more details.
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>. */
 
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
 #include <stdio.h>
 #include <stdlib.h>
 #include "assert.h"
--- a/src/libs/libgroff/errarg.cpp
+++ b/src/libs/libgroff/errarg.cpp
@@ -17,6 +17,10 @@ for more details.
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>. */
 
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
 #include <stdio.h>
 #include "assert.h"
 #include "errarg.h"
--- a/src/libs/libgroff/error.cpp
+++ b/src/libs/libgroff/error.cpp
@@ -17,6 +17,10 @@ for more details.
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>. */
 
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
--- a/src/preproc/eqn/eqn.ypp
+++ b/src/preproc/eqn/eqn.ypp
@@ -16,6 +16,10 @@ for more details.
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>. */
 %{
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
