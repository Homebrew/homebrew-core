class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "https://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.16.4.tar.gz"
  sha256 "71037b8281c6c86b0a55729f90d5db697abe4cbec1d8118157e00d48ec253467"
  license any_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://bitbucket.org/odedevs/ode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0db659d5d8b9f5b0a8391e07bf6dce76c6528ee142ef64227d27cd108c14fe76"
    sha256 cellar: :any,                 arm64_monterey: "2eb1e7ae85cec1e9d3686113190d8ec89fca460c58b81f3e978b20961d235cf6"
    sha256 cellar: :any,                 arm64_big_sur:  "f4cb558f0e993040046a0400a5d6aa69bd4916d5cac25e45597f2b6b72cbdb83"
    sha256 cellar: :any,                 ventura:        "e04a88ce07030af5f9f93f2bd035a4b89ea200a9d67a17ebd89c7ad5bc536565"
    sha256 cellar: :any,                 monterey:       "af90730fce7e61597be9dd2132e985386a47e59dde6ba23a16c42d4e6a0d44f2"
    sha256 cellar: :any,                 big_sur:        "21c78389a6a1999ea1c0a5deb90e779ae44cbe71affcc7b6c5ac5ce0d43af578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26dc057f117efea645ebf883369d7d48082b6a87a40443ad95e2d40f26d2ff48"
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
