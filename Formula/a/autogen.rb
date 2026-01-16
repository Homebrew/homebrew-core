class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.net/"
  url "https://ftpmirror.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  sha256 "f8a13466b48faa3ba99fe17a069e71c9ab006d9b1cfabe699f8c60a47d5bb49a"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(%r{href=.*?rel(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "11f0bdd04ae3db9ab2d6f2e12d2554db59111391ded8f941cd2bf08f79475f8a"
    sha256 arm64_sequoia: "4d986c1d9d478a402348836169d0a35f56a6fc9f7ad7f5d14acfd1bcd101b9c9"
    sha256 arm64_sonoma:  "58e8865aa281a5dea676f8ee73f750ef1e8f357dad557fb35c00c09a94d10566"
    sha256 sonoma:        "7748ba11598da28c7e554768ed83c34a3fed3e5c2eea7ff9ac5811b652dd11b0"
    sha256 arm64_linux:   "6778d7687bfc74353db0b0ae81d994322814df152f7ec42f576e5eb591fd2958"
    sha256 x86_64_linux:  "d109eab1f0b3a0293f60e0da2360694b3027ac39b0015e3573c57d10125da77f"
  end

  depends_on "coreutils" => :build
  depends_on "pkgconf" => :build

  depends_on "guile"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "bdw-gc"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # Fix guile detection, see https://sourceforge.net/p/autogen/bugs/196/
  patch :DATA

  def install
    # Uses GNU-specific mktemp syntax: https://sourceforge.net/p/autogen/bugs/189/
    inreplace %w[agen5/mk-stamps.sh build-aux/run-ag.sh config/mk-shdefs.in], "mktemp", "gmktemp"
    # Upstream bug regarding "stat" struct: https://sourceforge.net/p/autogen/bugs/187/
    system "./configure", "ac_cv_func_utimensat=no",
                          "--disable-silent-rules",
                          *std_configure_args

    # make and install must be separate steps for this formula
    system "make"
    system "make", "install"
  end

  test do
    system bin/"autogen", "-v"
  end
end

__END__
Index: autogen-5.18.16/agen5/guile-iface.h
===================================================================
--- autogen-5.18.16.orig/agen5/guile-iface.h
+++ autogen-5.18.16/agen5/guile-iface.h
@@ -9,16 +9,13 @@
 # error AutoGen does not work with this version of Guile
   choke me.

-#elif GUILE_VERSION < 203000
+#else
 # define AG_SCM_IS_PROC(_p)           scm_is_true( scm_procedure_p(_p))
 # define AG_SCM_LIST_P(_l)            scm_is_true( scm_list_p(_l))
 # define AG_SCM_PAIR_P(_p)            scm_is_true( scm_pair_p(_p))
 # define AG_SCM_TO_LONG(_v)           scm_to_long(_v)
 # define AG_SCM_TO_ULONG(_v)          ((unsigned long)scm_to_ulong(_v))

-#else
-# error unknown GUILE_VERSION
-  choke me.
 #endif

 #endif /* MUTATING_GUILE_IFACE_H_GUARD */
Index: autogen-5.18.16/configure
===================================================================
--- autogen-5.18.16.orig/configure
+++ autogen-5.18.16/configure
@@ -14798,7 +14798,7 @@ $as_echo "no" >&6; }
    PKG_CONFIG=""
  fi
 fi
-  _guile_versions_to_search="2.2 2.0 1.8"
+  _guile_versions_to_search="3.0 2.2 2.0 1.8"
   if test -n "$GUILE_EFFECTIVE_VERSION"; then
     _guile_tmp=""
     for v in $_guile_versions_to_search; do
