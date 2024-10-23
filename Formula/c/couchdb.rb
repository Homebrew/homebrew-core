class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.4.2/apache-couchdb-3.4.2.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.4.2/apache-couchdb-3.4.2.tar.gz"
  sha256 "d27ff2a13356000296a98ab884caf3d175927cf21727963ff90fab3a747544cf"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a44013c2e27ebd990529024fa539da1c241d1b564708f540411907242fc5d04e"
    sha256 cellar: :any,                 arm64_sonoma:  "3c71a671a3a1a93c061cb3dff96b55e7fb5f4a5f717f7eeb58a35ca69a3b88ba"
    sha256 cellar: :any,                 arm64_ventura: "bb06b7e504e850bb18aa0bfbe7676811b0b081363356f2c36629fe5e072cbc65"
    sha256 cellar: :any,                 sonoma:        "ea1169647969d3ccc96527f2a4d0970c5f43c66717851ec15cf44883d13bc40c"
    sha256 cellar: :any,                 ventura:       "870870e63980b33d41cb6e10fb26402192a7b08d440e08850eccdb7ef270f715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3f8e5d5559495f2050887c017496bca4b0b28ee6da6db5ff35547aff7b506b4"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@75"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  fails_with :gcc do
    version "5"
    cause "mfbt (and Gecko) require at least gcc 6.1 to build."
  end

  def install
    system "./configure", "--disable-spidermonkey", "--js-engine=quickjs"
    system "make", "release"
    # setting new database dir
    inreplace "rel/couchdb/etc/default.ini", "./data", "#{var}/couchdb/data"
    # remove windows startup script
    rm("rel/couchdb/bin/couchdb.cmd")
    # install files
    prefix.install Dir["rel/couchdb/*"]
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
