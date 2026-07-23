class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.19/libp11-0.4.19.tar.gz"
  sha256 "a344ca201ffa71822881e45e86457ab9a0115d07d03da0d69c7e5a7268255a35"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "97e58b3f8dbe3ec5427939e2e04dc4a2c8634fc5149e4d4f05b5f17e6430a7c2"
    sha256 cellar: :any, arm64_sequoia: "028157d1edea451f6a386c5266c18f1792203792c903d1ccfac452c6bd250950"
    sha256 cellar: :any, arm64_sonoma:  "6a8779d49170b3e092ef1a8156bda249f4aa5a74ed82cdeea9a25bb17564409f"
    sha256 cellar: :any, sonoma:        "dc621d302ee73159730d28fc7bc12f00de381aa095238748e579890c8fe84701"
    sha256 cellar: :any, arm64_linux:   "18f39b1aef751fd100d49a07600c2fc3ad0f22bae686206fb0bb4947dd967cea"
    sha256 cellar: :any, x86_64_linux:  "8fd4ff7067a37019406df915e9b55354f1ad8f1b11bc379ab7dcd9ba34a2c48c"
  end

  head do
    url "https://github.com/OpenSC/libp11.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "openssl@3"

  # Install missing `p11_ver.h` header
  # https://github.com/OpenSC/libp11/pull/662
  patch :DATA

  def install
    openssl = deps.find { |d| d.name.match?(/^openssl/) }
                  .to_formula
    enginesdir = Utils.safe_popen_read("pkgconf", "--variable=enginesdir", "libcrypto").chomp
    enginesdir.sub!(openssl.prefix.realpath, prefix)

    modulesdir = Utils.safe_popen_read("pkgconf", "--variable=modulesdir", "libcrypto").chomp
    modulesdir.sub!(openssl.prefix.realpath, prefix)

    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-enginesdir=#{enginesdir}",
                          "--with-modulesdir=#{modulesdir}",
                          *std_configure_args
    system "make", "install"
    pkgshare.install "examples/auth.c"
  end

  test do
    system ENV.cc, pkgshare/"auth.c", "-I#{Formula["openssl@3"].include}",
                   "-L#{lib}", "-L#{Formula["openssl@3"].lib}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end

__END__
diff --git a/src/Makefile.am b/src/Makefile.am
index 92d3fdb..549ac67 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -9,7 +9,7 @@ EXTRA_DIST = Makefile.mak libp11.rc.in pkcs11.rc.in
 
 # Headers
 noinst_HEADERS= libp11-int.h pkcs11.h p11_pthread.h provider_helpers.h util.h
-include_HEADERS= libp11.h p11_err.h
+include_HEADERS= libp11.h p11_err.h p11_ver.h
 
 lib_LTLIBRARIES = libp11.la
 enginesexec_LTLIBRARIES =
diff --git a/src/Makefile.in b/src/Makefile.in
index 797be54..4a1638d 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -492,7 +492,7 @@ EXTRA_DIST = Makefile.mak libp11.rc.in pkcs11.rc.in $(am__append_3)
 
 # Headers
 noinst_HEADERS = libp11-int.h pkcs11.h p11_pthread.h provider_helpers.h util.h
-include_HEADERS = libp11.h p11_err.h
+include_HEADERS = libp11.h p11_err.h p11_ver.h
 lib_LTLIBRARIES = libp11.la $(am__append_2)
 enginesexec_LTLIBRARIES = $(am__append_1)
 pkgconfig_DATA = libp11.pc
