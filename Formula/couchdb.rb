class Couchdb < Formula
  desc "Document database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/couchdb/source/1.7.1/apache-couchdb-1.7.1.tar.gz"
  sha256 "91200aa6fbc6fa5e2f3d78ef40e39d8c1ec7c83ea1c2cd730d270658735b2cad"
  revision 3

  bottle do
    sha256 "6215cd6abbf100a301579ef95d1c94a90c3c2bc84484a91edb0c88bb9b1ae626" => :high_sierra
    sha256 "dc124a774e54ae8368fb6ef46817d5d0c3d6a3997d9029c250ad186f9bbd681d" => :sierra
    sha256 "f3c634cb5313a11d485dea76f5326b4c04ac9b9b43a0fb909c3b1008ff3d711e" => :el_capitan
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

  depends_on "erlang@19"
  depends_on "spidermonkey"
  depends_on "icu4c"

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
                          "--with-erlang=#{Formula["erlang@19"].opt_lib}/erlang/usr/include",
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
    str = <<~EOS
      To test CouchDB run:
          curl http://127.0.0.1:5984/
      The reply should look like:
          {"couchdb":"Welcome","uuid":"....","version":"#{version}","vendor":{"version":"#{version}-1","name":"Homebrew"}}
    EOS
    str += "\n#{geocouch_caveats}" if build.with? "geocouch"
    str
  end

  def geocouch_caveats; <<~EOS
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

  def plist; <<~EOS
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
