class Couchdb < Formula
  desc "Document database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/couchdb/source/2.0.0/apache-couchdb-2.0.0.tar.gz"
  sha256 "ccaf3ce9cb06c50a73e091696e557e2a57c5ba02c5b299e1ac2f5b959ee96eca"

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

  depends_on "spidermonkey"
  depends_on "icu4c"
  depends_on "erlang"

  def install
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

    # Use our plist instead to avoid faffing with a new system user.
    (prefix/"Library/LaunchDaemons/org.apache.couchdb.plist").delete
    (lib/"couchdb/bin/couchjs").chmod 0755
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

  def caveats; <<-EOS.undent
      To test CouchDB run:
          curl http://127.0.0.1:5984/
      The reply should look like:
          {"couchdb":"Welcome","uuid":"....","version":"#{version}","vendor":{"version":"#{version}-1","name":"Homebrew"}}
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
