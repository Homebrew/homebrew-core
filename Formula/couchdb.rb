class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=/couchdb/source/2.3.1/apache-couchdb-2.3.1.tar.gz"
  sha256 "43eb8cec41eb52871bf22d35f3e2c2ce5b806ebdbce3594cf6b0438f2534227d"

  bottle do
    sha256 "3418496d83e41753b9c27beef215728342da499fd3e0881ca2830377aefe36e0" => :mojave
    sha256 "ad409da6a2a7fd3fe27d3b2bedec565e15d197fe82e9607924c9441a7954b7d5" => :high_sierra
    sha256 "d06ec7cd12e85e87126a4cb1b28f28b9d8fcda789f3aa62431c68731b14fd1f9" => :sierra
  end
  
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang@21" => :build
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
    bin.install Dir["rel/couchdb/bin/*"]
    prefix.install Dir["rel/couchdb/*"]
    (prefix/"Library/LaunchDaemons/org.apache.couchdb.plist").delete if File.exist?(prefix/"Library/LaunchDaemons/org.apache.couchdb.plist")
  end

  def post_install
    # creating database directory
    (var/"couchdb/data").mkpath
    # patching to start couchdb from symlinks
    inreplace "#{bin}/couchdb", 'COUCHDB_BIN_DIR=$(cd "${0%/*}" && pwd)',
'canonical_readlink ()
  {
  cd $(dirname $1);
  FILE=$(basename $1);
  if [ -h "$FILE" ]; then
    canonical_readlink $(readlink $FILE);
  else
    echo "$(pwd -P)";
  fi
}
COUCHDB_BIN_DIR=$(canonical_readlink $0)'
  end

  def caveats; <<~EOS
    If your upgrade from version 1.7.2_1 then your old database path is "/usr/local/var/lib/couchdb".

    The database path of this installation: #{var}/couchdb/data".

    If you want to migrate your data from 1.x to 2.x then follow this guide:
    https://docs.couchdb.org/en/stable/install/upgrading.html

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
        <string>#{bin}/couchdb</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    # copy config files
    cp_r prefix/"etc", testpath
    # setting database path to testpath
    inreplace "#{testpath}/etc/default.ini", "#{var}/couchdb/data", "#{testpath}/data"

    # start CouchDB with test environment
    pid = fork do
      exec "#{bin}/couchdb -couch_ini #{testpath}/etc/default.ini #{testpath}/etc/local.ini"
    end
    sleep 2

    begin
      assert_match "The Apache Software Foundation", shell_output("curl --silent localhost:5984")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
