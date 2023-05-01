class Log4cpp < Formula
  desc "Configurable logging for C++"
  homepage "https://log4cpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.4.tar.gz"
  sha256 "696113659e426540625274a8b251052cc04306d8ee5c42a0c7639f39ca90c9d6"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/log4cpp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4249d830f5c4e58d77d76a7cdf0eb84cd02a3c1150606e7795022ca8ba4b7abd"
    sha256 cellar: :any,                 arm64_monterey: "7ef34de1a9e3603252d924f37dc222b427287b26843603ca329bc395d3a0c4d2"
    sha256 cellar: :any,                 arm64_big_sur:  "6d5fcedb4afd7681c3ed5e6e65b300487527789144183e854d846a335c26b545"
    sha256 cellar: :any,                 ventura:        "60b1a66382660e797f3bb510043edc25dcab2b3512f1c9d11d2042d0980ae319"
    sha256 cellar: :any,                 monterey:       "8a710781fbbb6e0bf127e73411aefc490e63f2e17830f269039e0d865601974c"
    sha256 cellar: :any,                 big_sur:        "ff54331ebc21d9e5bcc75faf5af6750ce944485bd6cac293bd879c04c762dc7c"
    sha256 cellar: :any,                 catalina:       "3e08cff5384ae60222e67b63aadfda07534daa4d962b66167c5ffd8c1a55edf7"
    sha256 cellar: :any,                 mojave:         "0e0950a9b99a406b035e13c8acae673ce190a436920940d8150abe0c90cf1e84"
    sha256 cellar: :any,                 high_sierra:    "a80304325ab0f551054b169320c6f726f1c8a78d56eb56e7f14793c0f8cc8836"
    sha256 cellar: :any,                 sierra:         "db55c3b9dff2f2248d96c71672cb6032efc16a4803ce12dd52c278bd14b9abc8"
    sha256 cellar: :any,                 el_capitan:     "dee0bf8b96b1d0de3beb5f2d23cf1e868e6dfd3ec9814e2c4c5eab21432d73e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa93ce1f4cce44107a131667b2350814eb79a762c63c8bd4f35d283f21a25a10"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  # Our normal patch doesn't apply cleanly.
  patch :DATA

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end
end

__END__
diff --git a/configure b/configure
index 21e9738..a55f0fc 100755
--- a/configure
+++ b/configure
@@ -7506,16 +7506,11 @@ $as_echo "$lt_cv_ld_force_load" >&6; }
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
+	10.[012],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
