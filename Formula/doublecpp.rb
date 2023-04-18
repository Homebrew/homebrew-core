class Doublecpp < Formula
  desc "Double dispatch in C++"
  homepage "https://doublecpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/doublecpp/doublecpp/0.6.3/doublecpp-0.6.3.tar.gz"
  sha256 "232f8bf0d73795558f746c2e77f6d7cb54e1066cbc3ea7698c4fba80983423af"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fea45f833654d2f799d9fc1cb535238749b42a818d9718a7d73ecc94cfed74cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9f2d4540def16e3fe205cee4155fc21b5574879918ea7d9468ebf52f8245e39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26cdd6d6565fccc24bf7099bf4b2aa779c6e7dabe8908d408e929f4fbf861de7"
    sha256 cellar: :any_skip_relocation, ventura:        "b734b575fec9d1c01c97e96c283caf593ba17a2650bf5071e4523f0851d04e04"
    sha256 cellar: :any_skip_relocation, monterey:       "3ec3e4517d9a99533a08932492764f0578122528585b5955ef5f6b092a8ba806"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f4d63ed1afe1fa65825d925b8e90ff32e867de820c41159f52c4532a4df92b7"
    sha256 cellar: :any_skip_relocation, catalina:       "429cf6757b46b6f0289439d40db98e3a574a4bf0bde930f8b9ae25a55f4452cb"
    sha256 cellar: :any_skip_relocation, mojave:         "eed3920bd4e85e32542ce2a67fc9d928f8d8ddfceb0b48e80ddd9db30090e9e6"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ca161369434cba6763add99e4e470a495662c866a328b374c5d6184e687361cc"
    sha256 cellar: :any_skip_relocation, sierra:         "748af7fb63392453cc4b648cea20786173202f5c891b45765dbf374e4ac2c2d5"
    sha256 cellar: :any_skip_relocation, el_capitan:     "208aa405fce2959b47f705ab8ba9104e8eadec3e8e709bddd3117ef7b074bedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "989076ce2ebaba5ca834b159332a0e4b4bf15dd51d5dc2617594d367bffee9f2"
  end

  # Fix build failure because of missing #include <stdlib.h> on Linux.
  # Patch submitted to author by email.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/doublecpp", "--version"
  end
end

__END__
diff --git a/src/branchanalyser.cpp b/src/branchanalyser.cpp
index e6da619..feca23a 100755
--- a/src/branchanalyser.cpp
+++ b/src/branchanalyser.cpp
@@ -9,6 +9,7 @@
  ***************************************************************************/
 
 #include <assert.h>
+#include <stdlib.h>
 
 #include "branchanalyser.h"
 #include "multimethods.h"
diff --git a/src/parambinder.cpp b/src/parambinder.cpp
index b2c77b8..8402221 100755
--- a/src/parambinder.cpp
+++ b/src/parambinder.cpp
@@ -10,6 +10,7 @@
 #include "parambinder.h"
 
 #include <assert.h>
+#include <stdlib.h>
 
 #include "classdecl.h"
 #include "methparams.h"
diff --git a/src/programanalyser.cpp b/src/programanalyser.cpp
index 19e34ba..c69518a 100755
--- a/src/programanalyser.cpp
+++ b/src/programanalyser.cpp
@@ -9,6 +9,8 @@
  ***************************************************************************/
 #include "programanalyser.h"
 
+#include <stdlib.h>
+
 #include "multimethods.h"
 #include "methods.h"
 #include "multimethodtypes.h"
diff --git a/src/sourceanalyser.cpp b/src/sourceanalyser.cpp
index a87fde3..fb6ea5e 100755
--- a/src/sourceanalyser.cpp
+++ b/src/sourceanalyser.cpp
@@ -8,6 +8,8 @@
  *   (at your option) any later version.                                   *
  ***************************************************************************/
 
+#include <stdlib.h>
+
 #include "sourceanalyser.h"
 #include "fileutil.h"
 #include "progelems.hpp"
diff --git a/src/sourcemodifier.cpp b/src/sourcemodifier.cpp
index 5324f6f..84dc15c 100755
--- a/src/sourcemodifier.cpp
+++ b/src/sourcemodifier.cpp
@@ -10,6 +10,7 @@
 
 #include <assert.h>
 #include <iostream> // TODO: remove it when changed ProgElems cons
+#include <stdlib.h>
 
 #include "my_sstream.h"
 
