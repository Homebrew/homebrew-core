class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_23.tar.gz"
    sha256 "6192b6a8d141545dc54c00c1a7af7f502f990418d780dcae76074163070dbb86"

    depends_on "autoconf" => :build # for patch
    depends_on "automake" => :build # for patch

    # Add a configure option to disable opportunistic linking to collectd when CI
    # needs to build both formulae, e.g. perl PRs. In master/4.x, the configure.ac
    # was rewritten to support this by using a local m4 macro AX_WITH_LIB_ARGS_OPT.
    # TODO: Remove when upstream has option in stable release, or when Homebrew CI
    # is able to uninstall previously-built formulae to avoid unwanted linkage.
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "0ec020d5681af819217e88d69b32847374d2c741bc6c014019d9eab7c115f826"
    sha256 big_sur:       "2391ba3cd210a510891422e50436c6d9f6f6da3e7a98b3db3d2c8ea0f3bba310"
    sha256 catalina:      "ecbed108fde03090c41450fd0faab9ad0c6f5a1727a43d4c4b6e3519d9b607d9"
    sha256 mojave:        "da0356738b1575a928df644cd554876510ff45ea1c0ead6e86ccc9a0aa70bc11"
    sha256 x86_64_linux:  "e1cf4c5f2a4b5f4115691657761b9da118fd4f9f4f4ae474c774969bb094b1b9"
  end

  depends_on "openssl@1.1"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "readline"
  end

  def install
    # TODO: remove autoreconf when patch is no longer needed
    system "autoreconf", "--verbose", "--install", "--force" if build.stable?

    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@1.1"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@1.1"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
      --without-collectdclient
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    output = shell_output("#{bin}/smbencrypt homebrew")
    assert_match "77C8009C912CFFCF3832C92FC614B7D1", output
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 3fc6e9df03..e80f96c518 100644
--- a/configure.ac
+++ b/configure.ac
@@ -968,6 +968,22 @@ fi
 dnl Set by FR_SMART_CHECK_LIB
 LIBS="${old_LIBS}"
 
+dnl #
+dnl #  extra argument: --with-collectdclient
+dnl #
+WITH_COLLECTDCLIENT=yes
+AC_ARG_WITH(collectdclient,
+[  --with-collectdclient   use collectd client. (default=yes)],
+[ case "$withval" in
+  no)
+    WITH_COLLECTDCLIENT=no
+    ;;
+  *)
+    WITH_COLLECTDCLIENT=yes
+    ;;
+  esac ]
+)
+
 dnl Check for collectdclient
 dnl extra argument: --with-collectdclient-lib-dir=DIR
 collectdclient_lib_dir=
@@ -1001,16 +1017,18 @@ AC_ARG_WITH(collectdclient-include-dir,
       ;;
   esac])
 
-smart_try_dir="$collectdclient_lib_dir"
-FR_SMART_CHECK_LIB(collectdclient, lcc_connect)
-if test "x$ac_cv_lib_collectdclient_lcc_connect" != "xyes"; then
-  AC_MSG_WARN([collectdclient library not found. Use --with-collectdclient-lib-dir=<path>.])
-else
-  COLLECTDC_LIBS="${smart_lib}"
-  COLLECTDC_LDFLAGS="${smart_ldflags}"
+if test "x$WITH_COLLECTDCLIENT" = xyes; then
+  smart_try_dir="$collectdclient_lib_dir"
+  FR_SMART_CHECK_LIB(collectdclient, lcc_connect)
+  if test "x$ac_cv_lib_collectdclient_lcc_connect" != "xyes"; then
+    AC_MSG_WARN([collectdclient library not found. Use --with-collectdclient-lib-dir=<path>.])
+  else
+    COLLECTDC_LIBS="${smart_lib}"
+    COLLECTDC_LDFLAGS="${smart_ldflags}"
+  fi
+  dnl Set by FR_SMART_CHECKLIB
+  LIBS="${old_LIBS}"
 fi
-dnl Set by FR_SMART_CHECKLIB
-LIBS="${old_LIBS}"
 
 dnl Check for cap
 dnl extra argument: --with-cap-lib-dir=DIR
