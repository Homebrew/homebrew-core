class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.5.1/apache-couchdb-3.5.1.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.5.1/apache-couchdb-3.5.1.tar.gz"
  sha256 "c22cf31d6d91a3f5aa04f0cad493babdc723213494cb5e6170a507d359c50136"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c820b96084160809071315619ed09b6e94555f0325a5166d096422be4aebc4b2"
    sha256 cellar: :any,                 arm64_sequoia: "1f1dbc597dcd626977b1611e6ef24b66d53646ecb3455442a70d9ec89651b03a"
    sha256 cellar: :any,                 arm64_sonoma:  "7c2ba5172525d8f0188492d4aa4356e930895cee7d6fb1551d953db8dcb75e01"
    sha256 cellar: :any,                 sonoma:        "5d6a38935df1a21d017c4aeebb560a40e9a60635f246b754f1d751158f97d537"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "765eafa2052c4c62cc001a8073fab62d9e3cc8eead91d7ddf04f34fa6fe483fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7a932cbacacade0dbda15f9c4d5a177457d267f102ae3795bea2ec11fd6cee2"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  def install
    system "./configure", "--disable-spidermonkey", "--js-engine=quickjs"
    system "make", "release"
    # setting new database dir
    inreplace "rel/couchdb/etc/default.ini", "./data", "#{var}/couchdb/data"
    # remove windows startup script
    rm("rel/couchdb/bin/couchdb.cmd")
    # install files
    prefix.install Dir["rel/couchdb/*"]
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

  service do
    run opt_bin/"couchdb"
    keep_alive true
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
    sleep 30

    output = JSON.parse shell_output("curl --silent localhost:#{port}")
    assert_equal "Welcome", output["couchdb"]
  end
end
