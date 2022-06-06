class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_0.tar.gz"
    sha256 "2b8817472847e0b49395facd670be97071133730ffa825bb56386c89c18174f5"

    depends_on "autoconf" => :build # for patch
    depends_on "automake" => :build # for patch

    # Fix -flat_namespace being used
    patch do
      url "https://github.com/FreeRADIUS/freeradius-server/commit/6c1cdb0e75ce36f6fadb8ade1a69ba5e16283689.patch?full_index=1"
      sha256 "7e7d055d72736880ca8e1be70b81271dd02f2467156404280a117cb5dc8dccdc"
    end

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
    sha256 arm64_monterey: "2e379d98dca5701d1378fde394f170eb7e8e9ce8b0e03354a2f0f8ebbf85c6a7"
    sha256 arm64_big_sur:  "995d7ba020eb495a11ff6017580375564425f2b057f676b8be207d3be5e7559e"
    sha256 monterey:       "9234f76e27239a02cddd360c6952189c78ce9b5af621022da09ec2cd213eaaa0"
    sha256 big_sur:        "5c2c7208fbedddbc04b2af8eec2ed5e94bcd7faeb6e3bfde3b6816809c7e9993"
    sha256 catalina:       "be1b8a1d78e7cc9bccb2a6439408297a05a8af2adfef352cc84428c95e3715d6"
    sha256 x86_64_linux:   "768b37acaefc41960a324a7bf1f1ca41459c44c90a45e4bbd9a05f6bfdf571ca"
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
