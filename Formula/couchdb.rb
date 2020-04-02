class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.0.0/apache-couchdb-3.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.0.0/apache-couchdb-3.0.0.tar.gz"
  sha256 "d109bb1a70fe746c04a9bf79a2bb1096cb949c750c29dbd196e9c2efd4167fd9"
  revision 1

  bottle do
    cellar :any
    sha256 "58d868ce28a09017f44a09984817f7392b67823711bed0eb8a181e5c9bd5ebbe" => :catalina
    sha256 "ce0ff001d1c2b7468a17792a3d2e03acbce8c3d24d1129d94b1c663ec8171d5d" => :mojave
    sha256 "caf44b983810c045bab45176944cbbb464720db66070ba0e2bc0286d718acdff" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"
  depends_on "spidermonkey"

  def install
    system "./configure"
    system "make", "release"
    # setting new database dir
    inreplace "rel/couchdb/etc/default.ini", "./data", "#{var}/couchdb/data"
    # remove windows startup script
    File.delete("rel/couchdb/bin/couchdb.cmd") if File.exist?("rel/couchdb/bin/couchdb.cmd")
    # install files
    prefix.install Dir["rel/couchdb/*"]
    if File.exist?(prefix/"Library/LaunchDaemons/org.apache.couchdb.plist")
      (prefix/"Library/LaunchDaemons/org.apache.couchdb.plist").delete
    end
  end

  def post_install
    # creating database directory
    (var/"couchdb/data").mkpath
  end

  def caveats
    <<~EOS
      If your upgrade from version 1.7.2_1 then your old database path is "/usr/local/var/lib/couchdb".

      The database path of this installation: #{var}/couchdb/data".

      If you want to migrate your data from 1.x to 2.x then follow this guide:
      https://docs.couchdb.org/en/stable/install/upgrading.html

    EOS
  end

  plist_options :manual => "couchdb"

  def plist
    <<~EOS
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
          <string>#{bin}/couchdb</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    cp_r prefix/"etc", testpath
    port = free_port
    inreplace "#{testpath}/etc/default.ini", "port = 5984", "port = #{port}"
    inreplace "#{testpath}/etc/default.ini", "#{var}/couchdb/data", "#{testpath}/data"
    inreplace "#{testpath}/etc/local.ini", ";admin = mysecretpassword", "admin = mysecretpassword"

    fork do
      exec "#{bin}/couchdb -couch_ini #{testpath}/etc/default.ini #{testpath}/etc/local.ini"
    end
    sleep 2

    output = JSON.parse shell_output("curl --silent localhost:#{port}")
    assert_equal "Welcome", output["couchdb"]
  end
end
