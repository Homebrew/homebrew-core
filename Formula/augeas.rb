class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  license "LGPL-2.1"
  revision 1

  stable do
    url "http://download.augeas.net/augeas-1.12.0.tar.gz"
    sha256 "321942c9cc32185e2e9cb72d0a70eea106635b50269075aca6714e3ec282cb87"
    # This patch is needed until
    # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44605 is resolved and makes
    # its way to an Augeas release. When this patch is deleted, the
    # unconditional autoconf and automake build dependencies can be removed.
    patch :DATA
  end

  livecheck do
    url "http://download.augeas.net/"
    regex(/href=.*?augeas[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "a470a4b47f5072f27cf308fac97ff3b9cdd30f88aa4a950fbc73a4527ec9c6ba"
    sha256 big_sur:       "339c6898b7b3fd115fc3cc3c9a0cdb3eb6a1eab3f492e5f2de6513d7c6171c0e"
    sha256 catalina:      "00a45b8b446df0a95c2c45cbe608410df2d7be7787247f4b3a8fc1c2c19b41b6"
    sha256 mojave:        "9a561491e3574dfe2cfe7da2a618c12d02218f88f760de46722d9b603e4f27ba"
    sha256 high_sierra:   "0e1477f692cf67442dfcaf7c20a24733838df072ec867f59322070a7eaf3f925"
    sha256 sierra:        "55b3fab93f2ec4a703dc2bb3b3d58c47375456bdb5f0308e0856b231d309c02d"
    sha256 x86_64_linux:  "6d95bdecb26786ee6aaaae8fe49ce90d91a10782d9c6f55d6b2de37d4b5e8aea"
  end

  head do
    url "https://github.com/hercules-team/augeas.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  def caveats
    <<~EOS
      Lenses have been installed to:
        #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end

  test do
    system bin/"augtool", "print", etc
  end
end

__END__
diff --git a/configure b/configure
index 4b8fb40..b8b62da 100755
--- a/configure
+++ b/configure
@@ -11039,16 +11039,11 @@ $as_echo "$lt_cv_ld_force_load" >&6; }
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[91]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[012][,.]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+        10.[[012]],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+        *)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
diff --git a/gnulib/m4/libtool.m4 b/gnulib/m4/libtool.m4
index a644432..c8a4d45 100644
--- a/gnulib/m4/libtool.m4
+++ b/gnulib/m4/libtool.m4
@@ -1067,16 +1067,11 @@ _LT_EOF
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[[91]]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[[012]][[,.]]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+       10.[[012]],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
