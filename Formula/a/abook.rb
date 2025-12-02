class Abook < Formula
  desc "Address book with mutt support"
  homepage "https://abook.sourceforge.io/"
  license all_of: [
    "GPL-3.0-only",
    "GPL-2.0-or-later",  # mbswidth.c
    "LGPL-2.0-or-later", # getopt.c
    "BSD-2-Clause",      # xmalloc.c
    "BSD-4.3RENO",       # ldif.c
  ]
  head "https://git.code.sf.net/p/abook/git.git", branch: "master"

  stable do
    url "https://git.code.sf.net/p/abook/git.git",
        tag:      "ver_0_6_2",
        revision: "a243d4a18a64f4ee188191a797b34f60d4ff852f"

    # Backport include from https://sourceforge.net/p/abook/git/ci/39484721c44629fb1f54d92f09c92ef4c3201302/
    patch :DATA
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "4179f858a3406d98bbf021e5a431cf064b6430839a4210643925af38a9c037af"
    sha256 arm64_sequoia: "b0113dcc3ee161e37ed8c9fbdab0175486bf04c3a5e802b46dde3b015fe67cac"
    sha256 arm64_sonoma:  "bbdac04e9da720845e5ee41ba19af9541a62d953c4c9929170400c84dcad3e32"
    sha256 arm64_ventura: "7ac157f6847b43e07454da28ffefc1911c891c1a7d642d3ad31d7d12166ee42b"
    sha256 sonoma:        "aaa8b661464c11cc8329a8b9da48ff5088df6b5e556eded5f32970c441858626"
    sha256 ventura:       "192d1342a247240817e4a4235341eeb440c79d042ec092dbc784015fb346efa4"
    sha256 arm64_linux:   "643aa6b526a1b5c3d01a072633e346efa165c3c5ed2804a5ed516cce7d1b5ac9"
    sha256 x86_64_linux:  "20347763d0c3ac3e729619fcf98b65e72f0931ddd7ca55d51f2c26d62e1f5147"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"abook", "--formats"
  end
end

__END__
diff --git a/database.c b/database.c
index 384223e..eb9b4b0 100644
--- a/database.c
+++ b/database.c
@@ -12,6 +12,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <assert.h>
+#include <ctype.h>
 #ifdef HAVE_CONFIG_H
 #      include "config.h"
 #endif
