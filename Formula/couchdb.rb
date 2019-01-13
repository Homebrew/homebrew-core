class Couchdb < Formula
  desc "Document database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/couchdb/source/1.7.1/apache-couchdb-1.7.1.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/1.7.1/apache-couchdb-1.7.1.tar.gz"
  sha256 "91200aa6fbc6fa5e2f3d78ef40e39d8c1ec7c83ea1c2cd730d270658735b2cad"
  revision 8

  bottle do
    sha256 "81a9ef09e872ead7a3ae847f57f6cd01f4e7e46384c456b1cf4162cf7eecab42" => :mojave
    sha256 "726a7e2329d938f0d64552a2b5c724fc665b5de8b1d046c9fdbd270cf941ba44" => :high_sierra
    sha256 "3b5ed55595f163362f6a583a13fae6353c79b2cf9e66f0d35bcf7e5f13a38613" => :sierra
  end

  head do
    url "https://github.com/apache/couchdb.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "erlang@19"
  depends_on "icu4c"
  depends_on "spidermonkey"

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

  def caveats; <<~EOS
    To test CouchDB run:
        curl http://127.0.0.1:5984/
    The reply should look like:
        {"couchdb":"Welcome","uuid":"....","version":"#{version}","vendor":{"version":"#{version}-1","name":"Homebrew"}}
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
