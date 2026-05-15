class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.5.1/apache-couchdb-3.5.1.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.5.1/apache-couchdb-3.5.1.tar.gz"
  sha256 "c22cf31d6d91a3f5aa04f0cad493babdc723213494cb5e6170a507d359c50136"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "b82b5b5a4b8eb3288a1a4fae6c95c275580ea9559f1caaebd287a06584208b21"
    sha256 cellar: :any,                 arm64_sequoia: "f0e6024d3ff3e28497c84bd5276c7c6670cebdfae50bf4c619aab8df47e83cf6"
    sha256 cellar: :any,                 arm64_sonoma:  "a8fbb5840644059150b97b5ceea647f9ee2c52eedbe6ee471b0b6ff284a345a9"
    sha256 cellar: :any,                 sonoma:        "6829502be2b2ef5a4caabeb6f6471838e7125f3cc1b0d44625025faaac4d24cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a37c144e35ca34649860426938a992fb8e84a97c254da671508b2d648bf4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed51cd3f5e7a3362173412c76b84393a68855bfec5b01dc68a9bc3513b559236"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    inreplace "etc/local.ini", ";admin = mysecretpassword", "admin = mysecretpassword"
    inreplace "etc/default.ini" do |s|
      s.gsub! "port = 5984", "port = #{port}"
      s.gsub! "#{var}/couchdb/data", testpath/"data"
    end

    spawn bin/"couchdb", "-couch_ini", testpath/"etc/default.ini", testpath/"etc/local.ini"
    output = JSON.parse(shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}"))
    assert_equal "Welcome", output["couchdb"]
  end
end
