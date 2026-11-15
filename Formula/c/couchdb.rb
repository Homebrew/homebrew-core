class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.5.3/apache-couchdb-3.5.3.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.5.3/apache-couchdb-3.5.3.tar.gz"
  sha256 "ae0bb374cc89900d6cb1dfb8d8e80c799186dcf2d143ca886296c230af420896"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "eec8fe14f6f743f5b551e2dbf09946696adb8970509b15ba72c3a08665475f75"
    sha256 cellar: :any, arm64_tahoe:       "1dea58d449cb9c9b3234d4e6a2c6d72562e9cfaefb7838753db8d0a0a345adce"
    sha256 cellar: :any, arm64_sequoia:     "a7e95e7bdbe02a677770a13c6dde80c2b980661099f36c15631aa92a4b7a65f3"
    sha256 cellar: :any, arm64_linux:       "3317caffd81f179654d2cc0947a5b675c70f13b90baa6dd7e3ecffbd950771f3"
    sha256 cellar: :any, x86_64_linux:      "7a2e721ec0436589826c4953143e043a6981c90d6f572b20b95341707365feb1"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@79"
  depends_on "openssl@4"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  allow_network_access! :test

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
