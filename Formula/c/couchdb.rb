class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.4.2/apache-couchdb-3.4.2.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.4.2/apache-couchdb-3.4.2.tar.gz"
  sha256 "d27ff2a13356000296a98ab884caf3d175927cf21727963ff90fab3a747544cf"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "efa8510c21cc57b74648d6d0d2f86301170bf1e791d61888561726f4bdaf9e8d"
    sha256 cellar: :any,                 arm64_sonoma:  "c04b2291c6914ab5a359ccfb87d212bbe52ea50217a2e5d28408642eaf99a19d"
    sha256 cellar: :any,                 arm64_ventura: "1bae3874a3219b0f1d03962d0d7361eef68071a512d381f17143031312d0cf9d"
    sha256 cellar: :any,                 sonoma:        "1948c2c92ef82cd062fda485a71cb65cc65421d68c50d8d79e69e3108ef1fc51"
    sha256 cellar: :any,                 ventura:       "c8cd50bd8ad1ad9fc6b19e34929054bec703718d7b67c3451d5be92a745e24d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d7f5a9a3e96d4032b99003c6d065e7ac14f8229ad98cf93f557bb1a47020e49"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@76"
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
