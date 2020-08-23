class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.1.0/apache-couchdb-3.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.1.0/apache-couchdb-3.1.0.tar.gz"
  sha256 "4867c796a1ff6f0794b7bd3863089ea6397bd5c47544f9b97db8cdacff90f8ed"
  license "Apache-2.0"
  revision 2

  bottle do
    cellar :any
    sha256 "0e3d1fa0ce2afb1e38f3b141b8d7cb66211823bd57f8b72733f0261c76cf8795" => :catalina
    sha256 "8a7a59746933d3b07ac907fde5b5c5b5d4ae81323155a17b683a6bb543a7383e" => :mojave
    sha256 "289e443dd84e008c79649c239078890f7a2c4e5358c13b88e79002bace31b497" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang@22" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"
  depends_on "spidermonkey"

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

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

  plist_options manual: "couchdb"

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
