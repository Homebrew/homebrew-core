class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "https://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.16.6.tar.gz"
  sha256 "c91a28c6ff2650284784a79c726a380d6afec87ecf7a35c32a6be0c5b74513e8"
  license any_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://bitbucket.org/odedevs/ode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f85029563540277a80dfb3ed714d68d2dcb7e06d32b6bd190a07d6fa5f91847f"
    sha256 cellar: :any,                 arm64_sequoia: "3aa96ecd0a92215d8005fb5f663c51b40df82454815f7bf5ab18f29ecef9d401"
    sha256 cellar: :any,                 arm64_sonoma:  "18918632c616a8dcebb91fd9f717133b8921bc1fb1c383e2da6b8fee8debb26d"
    sha256 cellar: :any,                 arm64_ventura: "c36bfd094cdf7c2cc6d877f05e7fba556fb012bd9ef5948b097e14f0b596be15"
    sha256 cellar: :any,                 sonoma:        "3ee055bde9ea2aca43d4305de3cad0aeda9f54a3a1ff69dde4618487223f792b"
    sha256 cellar: :any,                 ventura:       "2579b830d5c07a1c799bfee7bc1c0536614da23483a02190ad6d2f87585d84b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc65c81c28d4007bdfcaf7398d065c55ee477bbd4dd37abb7017810cb457fe5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb0f3a0439ddeada4699c0ca1004810a676e4bb07d910464d9641b3b5b4dddc1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
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
    (testpath/"test.cpp").write <<~CPP
      #include <ode/ode.h>
      int main() {
        dInitODE();
        dCloseODE();
        return 0;
      }
    CPP
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
