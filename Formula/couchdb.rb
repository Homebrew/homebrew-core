class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.1.1/apache-couchdb-3.1.1.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.1.1/apache-couchdb-3.1.1.tar.gz"
  sha256 "8ffe766bba2ba39a7b49689a0732afacf69caffdf8e2d95447e82fb173c78ca3"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "8d192716d7cb1aabe1e0d556ee86717c11c9079e18699d718ffd3aa7c94d57ec" => :catalina
    sha256 "d683b22eecb84fe5326b8644d8ff5a0f72a0c935e84d0411369271e521a7b7dc" => :mojave
    sha256 "ba42a4ef666858aa21beccaa8b3d80799860e5501af9453dd649988d5603cade" => :high_sierra
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
      CouchDB 3.x requires a set admin password set before startup.
      Add one to your #{etc}/local.ini before starting CouchDB e.g.:
        [admins]
        admin = youradminpassword
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
