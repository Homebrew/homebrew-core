class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "https://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.16.5.tar.gz"
  sha256 "ba875edd164570958795eeaa70f14853bfc34cc9871f8adde8da47e12bd54679"
  license any_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  revision 1
  head "https://bitbucket.org/odedevs/ode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "58790fb1f2cc52d91f1bcaead540caa03b531dafef534468786e9ac48e1a109d"
    sha256 cellar: :any,                 arm64_sonoma:   "1dfefe85ef027eff13206f91fcfb6e3f5c24f620b15351cbf464d26cab397f05"
    sha256 cellar: :any,                 arm64_ventura:  "c363d1cfd6ba84dfd8193cf0f35d0692892679c8c11c2ea75ccce157c1af3811"
    sha256 cellar: :any,                 arm64_monterey: "947a229707651468f4ec56e1a16508d495b934070413683d2ba73abf6abd8211"
    sha256 cellar: :any,                 sonoma:         "7a19db0009214d0c78def3ecb8327137603967f5bc65bc7f11debb715dc7022a"
    sha256 cellar: :any,                 ventura:        "9334eda731f3105d30a93600393140d690e80fb05791d9a63dc99601641a8888"
    sha256 cellar: :any,                 monterey:       "7d6ed1dc202b74d76cc339fb17c96626dad0faf626dad2474f957590e0b15165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5158488ea35492840d91d5d4cfd4cff98c4d26003e230be5214dc1320bca74c1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libccd"

  # Fix -flat_namespace being used on Big Sur and later.
  # We patch `libtool.m4` and not `configure` because we call `./bootstrap`.
  patch :DATA

  def install
    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "./bootstrap"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-libccd",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-demos",
                          "--enable-double-precision"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ode/ode.h>
      int main() {
        dInitODE();
        dCloseODE();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/ode", "-L#{lib}", "-lode",
                   "-L#{Formula["libccd"].opt_lib}", "-lccd", "-lm", "-lpthread",
                   "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/m4/libtool.m4 b/m4/libtool.m4
index 10ab284..bfc1d56 100644
--- a/m4/libtool.m4
+++ b/m4/libtool.m4
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
+	10.[[012]],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
