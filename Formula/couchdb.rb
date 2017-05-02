class Couchdb < Formula
  desc "Document database server"
  homepage "https://couchdb.apache.org/"
  revision 9

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz"
    sha256 "5a601b173733ce3ed31b654805c793aa907131cd70b06d03825f169aa48c8627"

    # Support Erlang/OTP 18.0+ compatibility, see upstream #95cb436
    # It will be in the next CouchDB point release, likely 1.6.2.
    # https://github.com/apache/couchdb/pull/431
    patch :DATA
  end

  bottle do
    sha256 "2a3dd04b37456370b311c30bfeb18bc233e9741fd7d87ae6ba356d2b650e9bfa" => :sierra
    sha256 "4a5565cf75f12fea70823b9ec2bd6e8dccdfc7b0f96c31331380d6910abcd0d4" => :el_capitan
    sha256 "06e0a67d125f908efa45426cd903ae2192f0742879a91390659254f2f1a27988" => :yosemite
  end

  head do
    url "https://github.com/apache/couchdb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "autoconf-archive" => :build
    depends_on "pkg-config" => :build
    depends_on "help2man" => :build
  end

  option "with-geocouch", "Build with GeoCouch spatial index extension"

  depends_on "spidermonkey"
  depends_on "icu4c"
  depends_on "erlang"
  depends_on "curl" if MacOS.version <= :leopard

  resource "geocouch" do
    url "https://github.com/couchbase/geocouch/archive/couchdb1.3.x.tar.gz"
    sha256 "1bad2275756e2f03151d7b2706c089b3059736130612de279d879db91d4b21e7"
  end

  def install
    # CouchDB >=1.3.0 supports vendor names and versioning
    # in the welcome message
    inreplace "etc/couchdb/default.ini.tpl.in" do |s|
      s.gsub! "%package_author_name%", "Homebrew"
      s.gsub! "%version%", pkg_version
    end

    unless build.stable?
      # workaround for the auto-generation of THANKS file which assumes
      # a developer build environment incl access to git sha
      touch "THANKS"
      system "./bootstrap"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--disable-init",
                          "--with-erlang=#{HOMEBREW_PREFIX}/lib/erlang/usr/include",
                          "--with-js-include=#{HOMEBREW_PREFIX}/include/js",
                          "--with-js-lib=#{HOMEBREW_PREFIX}/lib"
    system "make"
    system "make", "install"

    install_geocouch if build.with? "geocouch"

    # Use our plist instead to avoid faffing with a new system user.
    (prefix/"Library/LaunchDaemons/org.apache.couchdb.plist").delete
    (lib/"couchdb/bin/couchjs").chmod 0755
  end

  def geocouch_share
    share/"couchdb-geocouch"
  end

  def install_geocouch
    resource("geocouch").stage(buildpath/"geocouch")
    ENV["COUCH_SRC"] = "#{buildpath}/src/couchdb"

    cd "geocouch" do
      system "make"

      linked_geocouch_share = (HOMEBREW_PREFIX/"share/couchdb-geocouch")
      geocouch_share.mkpath
      geocouch_share.install "ebin"
      # Install geocouch.plist for launchctl support.
      geocouch_plist = geocouch_share/"geocouch.plist"
      cp buildpath/"etc/launchd/org.apache.couchdb.plist.tpl.in", geocouch_plist
      geocouch_plist.chmod 0644
      inreplace geocouch_plist, "<string>org.apache.couchdb</string>", \
        "<string>geocouch</string>"
      inreplace geocouch_plist, "<key>HOME</key>", <<-EOS.lstrip.chop
        <key>ERL_FLAGS</key>
        <string>-pa #{linked_geocouch_share}/ebin</string>
        <key>HOME</key>
      EOS
      inreplace geocouch_plist, "%bindir%/%couchdb_command_name%", \
        HOMEBREW_PREFIX/"bin/couchdb"
      #  Turn off RunAtLoad and KeepAlive (to simplify experience for first-timers)
      inreplace geocouch_plist, "<key>RunAtLoad</key>\n    <true/>",
        "<key>RunAtLoad</key>\n    <false/>"
      inreplace geocouch_plist, "<key>KeepAlive</key>\n    <true/>",
        "<key>KeepAlive</key>\n    <false/>"
      #  Install geocouch.ini into couchdb.
      (etc/"couchdb/default.d").install "etc/couchdb/default.d/geocouch.ini"

      #  Install tests into couchdb.
      test_files = Dir["share/www/script/test/*.js"]
      (pkgshare/"www/script/test").install test_files
      #  Complete the install by referencing the geocouch tests in couch_tests.js
      #  (which runs the tests).
      test_lines = ["//  GeoCouch Tests..."]
      test_lines.concat(test_files.map { |file| file.gsub(%r{^.*\/(.*)$}, 'loadTest("\1");') })
      test_lines << "//  ...GeoCouch Tests"
      (pkgshare/"www/script/couch_tests.js").append_lines test_lines
    end
  end

  def post_install
    (var/"lib/couchdb").mkpath
    (var/"log/couchdb").mkpath
    (var/"run/couchdb").mkpath
    # default.ini is owned by CouchDB and marked not user-editable
    # and must be overwritten to ensure correct operation.
    if (etc/"couchdb/default.ini.default").exist?
      # but take a backup just in case the user didn't read the warning.
      mv etc/"couchdb/default.ini", etc/"couchdb/default.ini.old"
      mv etc/"couchdb/default.ini.default", etc/"couchdb/default.ini"
    end
  end

  def caveats
    str = <<-EOS.undent
    To test CouchDB run:
        curl http://127.0.0.1:5984/
    The reply should look like:
        {"couchdb":"Welcome","uuid":"....","version":"#{version}","vendor":{"version":"#{version}-1","name":"Homebrew"}}
    EOS
    str += "\n#{geocouch_caveats}" if build.with? "geocouch"
    str
  end

  def geocouch_caveats; <<-EOS.undent
    GeoCouch Caveats:
    FYI:  geocouch installs as an extension of couchdb, so couchdb effectively
    becomes geocouch.  However, you can use couchdb normally (using geocouch
    extensions optionally).  NB: one exception: the couchdb test suite now
    includes several geocouch tests.
    To start geocouch manually and verify any geocouch version information (-V),
      ERL_FLAGS="-pa #{geocouch_share}/ebin"  couchdb -V
    For general convenience, export your ERL_FLAGS (erlang flags, above) in
    your login shell, and then start geocouch:
      export ERL_FLAGS="-pa #{geocouch_share}/ebin"
      couchdb
    Alternately, prepare launchctl to start/stop geocouch as follows:
      cp #{geocouch_share}/geocouch.plist ~/Library/LaunchAgents
      chmod 0644 ~/Library/LaunchAgents/geocouch.plist
      launchctl load ~/Library/LaunchAgents/geocouch.plist
    Then start, check status of, and stop geocouch with the following three
    commands.
      launchctl start geocouch
      launchctl list geocouch
      launchctl stop geocouch
    Finally, access, test, and configure your new geocouch with:
      http://127.0.0.1:5984
      http://127.0.0.1:5984/_utils/couch_tests.html?script/couch_tests.js
      http://127.0.0.1:5984/_utils
    And... relax.
    -=-
    To uninstall geocouch from your couchdb installation, uninstall couchdb
    and re-install it without the '--with-geocouch' option.
      brew uninstall couchdb
      brew install couchdb
    To see these instructions again, just run 'brew info couchdb'.
    EOS
  end

  plist_options :manual => "couchdb"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/couchdb</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    # ensure couchdb embedded spidermonkey vm works
    system "#{bin}/couchjs", "-h"

    (testpath/"var/lib/couchdb").mkpath
    (testpath/"var/log/couchdb").mkpath
    (testpath/"var/run/couchdb").mkpath
    cp_r etc/"couchdb", testpath
    inreplace "#{testpath}/couchdb/default.ini", "/usr/local/var", testpath/"var"

    pid = fork do
      ENV["ERL_LIBS"] = geocouch_share if build.with? "geocouch"
      exec "#{bin}/couchdb -A #{testpath}/couchdb"
    end
    sleep 2

    begin
      assert_match "Homebrew", shell_output("curl -# localhost:5984")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

__END__
commit 95cb436be30305efa091809813b64ef31af968c8
Author: Dave Cottlehuber <dch@apache.org>
Date:   Fri Jun 26 10:31:27 2015 +0200

    build: support OTP-19.0

diff --git a/INSTALL.Unix b/INSTALL.Unix
index f66f98c..4c63bc8 100644
--- a/INSTALL.Unix
+++ b/INSTALL.Unix
@@ -39,7 +39,7 @@ Dependencies

 You should have the following installed:

- * Erlang OTP (>=R14B01, =<R17) (http://erlang.org/)
+ * Erlang OTP (>=R14B01, =<R19) (http://erlang.org/)
  * ICU                          (http://icu-project.org/)
  * OpenSSL                      (http://www.openssl.org/)
  * Mozilla SpiderMonkey (1.8.5) (http://www.mozilla.org/js/spidermonkey/)
diff --git a/INSTALL.Windows b/INSTALL.Windows
index 29c69b0..1ca04fd 100644
--- a/INSTALL.Windows
+++ b/INSTALL.Windows
@@ -29,7 +29,7 @@ Dependencies

 You will need the following installed:

- * Erlang OTP (>=14B01, <R17)    (http://erlang.org/)
+ * Erlang OTP (>=14B01, <R19)    (http://erlang.org/)
  * ICU        (>=4.*)            (http://icu-project.org/)
  * OpenSSL    (>=0.9.8r)         (http://www.openssl.org/)
  * Mozilla SpiderMonkey (=1.8.5) (http://www.mozilla.org/js/spidermonkey/)
diff --git a/configure.ac b/configure.ac
index 103f029..bf9ffc4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -411,7 +411,7 @@ esac

 { $as_echo "$as_me:${as_lineno-$LINENO}: checking Erlang version compatibility" >&5
 $as_echo_n "checking Erlang version compatibility... " >&6; }
-erlang_version_error="The installed Erlang version must be >= R14B (erts-5.8.1) and =< 17 (erts-6.0)"
+erlang_version_error="The installed Erlang version must be >= R14B (erts-5.8.1) and =< 19 (erts-8.0.1)"

 version="`${ERL} -version 2>&1 | ${SED} 's/[[^0-9]]/ /g'` 0 0 0"
 major_version=`echo $version | ${AWK} "{print \\$1}"`
@@ -419,7 +419,7 @@ minor_version=`echo $version | ${AWK} "{print \\$2}"`
 patch_version=`echo $version | ${AWK} "{print \\$3}"`
 echo -n "detected Erlang version: $major_version.$minor_version.$patch_version..."

-if test $major_version -lt 5 -o $major_version -gt 6; then
+if test $major_version -lt 5 -o $major_version -gt 8; then
     as_fn_error $? "$erlang_version_error major_version does not match" "$LINENO" 5
 fi

@@ -438,9 +438,9 @@ otp_release="`\
 AC_SUBST(otp_release)

 AM_CONDITIONAL([USE_OTP_NIFS],
-    [can_use_nifs=$(echo $otp_release | grep -E "^(R14B|R15|R16|17)")])
+    [can_use_nifs=$(echo $otp_release | grep -E "^(R14B|R15|R16|17|18|19)")])
 AM_CONDITIONAL([USE_EJSON_COMPARE_NIF],
-    [can_use_ejson=$(echo $otp_release | grep -E "^(R14B03|R15|R16|17)")])
+    [can_use_ejson=$(echo $otp_release | grep -E "^(R14B03|R15|R16|17|18|19)")])

 has_crypto=`\
     ${ERL} -eval "\
diff --git a/share/doc/src/install/unix.rst b/share/doc/src/install/unix.rst
index 76fe922..904c128 100644
--- a/share/doc/src/install/unix.rst
+++ b/share/doc/src/install/unix.rst
@@ -52,7 +52,7 @@ Dependencies

 You should have the following installed:

-* `Erlang OTP (>=R14B01, =<R17) <http://erlang.org/>`_
+* `Erlang OTP (>=R14B01, =<R19) <http://erlang.org/>`_
 * `ICU                          <http://icu-project.org/>`_
 * `OpenSSL                      <http://www.openssl.org/>`_
 * `Mozilla SpiderMonkey (1.8.5) <http://www.mozilla.org/js/spidermonkey/>`_
diff --git a/share/doc/src/install/windows.rst b/share/doc/src/install/windows.rst
index b7b66af..494ef65 100644
--- a/share/doc/src/install/windows.rst
+++ b/share/doc/src/install/windows.rst
@@ -90,7 +90,7 @@ Dependencies

 You should have the following installed:

-* `Erlang OTP (>=14B01, <R17)    <http://erlang.org/>`_
+* `Erlang OTP (>=14B01, <R19)    <http://erlang.org/>`_
 * `ICU        (>=4.*)            <http://icu-project.org/>`_
 * `OpenSSL    (>0.9.8r)          <http://www.openssl.org/>`_
 * `Mozilla SpiderMonkey (=1.8.5) <http://www.mozilla.org/js/spidermonkey/>`_
--- a/configure	2015-06-27 12:56:30.000000000 +0200
+++ b/configure	2015-06-27 12:58:38.000000000 +0200
@@ -18532,7 +18532,7 @@

 { $as_echo "$as_me:${as_lineno-$LINENO}: checking Erlang version compatibility" >&5
 $as_echo_n "checking Erlang version compatibility... " >&6; }
-erlang_version_error="The installed Erlang version must be >= R14B (erts-5.8.1) and =< 17 (erts-6.0)"
+erlang_version_error="The installed Erlang version must be >= R14B (erts-5.8.1) and =< 19 (erts-8.0.1)"

 version="`${ERL} -version 2>&1 | ${SED} 's/[^0-9]/ /g'` 0 0 0"
 major_version=`echo $version | ${AWK} "{print \\$1}"`
@@ -18540,7 +18540,7 @@
 patch_version=`echo $version | ${AWK} "{print \\$3}"`
 echo -n "detected Erlang version: $major_version.$minor_version.$patch_version..."

-if test $major_version -lt 5 -o $major_version -gt 6; then
+if test $major_version -lt 5 -o $major_version -gt 8; then
     as_fn_error $? "$erlang_version_error major_version does not match" "$LINENO" 5
 fi

@@ -18559,7 +18559,7 @@



- if can_use_nifs=$(echo $otp_release | grep -E "^(R14B|R15|R16|17)"); then
+ if can_use_nifs=$(echo $otp_release | grep -E "^(R14B|R15|R16|17|18|19)"); then
   USE_OTP_NIFS_TRUE=
   USE_OTP_NIFS_FALSE='#'
 else
@@ -18567,7 +18567,7 @@
   USE_OTP_NIFS_FALSE=
 fi

- if can_use_ejson=$(echo $otp_release | grep -E "^(R14B03|R15|R16|17)"); then
+ if can_use_ejson=$(echo $otp_release | grep -E "^(R14B03|R15|R16|17|18|19)"); then
   USE_EJSON_COMPARE_NIF_TRUE=
   USE_EJSON_COMPARE_NIF_FALSE='#'
 else
