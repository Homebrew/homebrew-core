class ApacheCouchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=/couchdb/source/2.3.1/apache-couchdb-2.3.1.tar.gz"
  sha256 "43eb8cec41eb52871bf22d35f3e2c2ce5b806ebdbce3594cf6b0438f2534227d"

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang@21" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "spidermonkey"

  def install
    system "./configure"
    system "make", "release"
    inreplace "rel/couchdb/etc/default.ini", "./data", "#{var}/couchdb/data"
    File.delete("rel/couchdb/bin/couchdb.cmd") if File.exist?("rel/couchdb/bin/couchdb.cmd")
    bin.install Dir["rel/couchdb/bin/*"]
    prefix.install Dir["rel/couchdb/*"]
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
    The database path of this installation: #{var}/couchdb/data"
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
