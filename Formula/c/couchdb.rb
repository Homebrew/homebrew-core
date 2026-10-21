class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.5.3/apache-couchdb-3.5.3.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.5.3/apache-couchdb-3.5.3.tar.gz"
  sha256 "ae0bb374cc89900d6cb1dfb8d8e80c799186dcf2d143ca886296c230af420896"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9952c668b91962ae2743dd704ef7abc4aada7cd28ebaa7dad25ab6cf17e9265b"
    sha256 cellar: :any, arm64_tahoe:       "e66fcdbda6684cd8142cb435c1d5dc94fd387feecbbaa234195b4ecb3b6c29ec"
    sha256 cellar: :any, arm64_sequoia:     "c78e0c26298f64fb210f16104b4456624a9b6c940047ffa8cb70668061abfcae"
    sha256 cellar: :any, arm64_linux:       "2327bf89d8f59fc72e22ce7f1f29b17c117a6b2e5d9e1c273a197b0ebd6364a8"
    sha256 cellar: :any, x86_64_linux:      "1c0574939ea368405c804452ef130c1eb3ddc571230d0b784a96bfb1100cdc28"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang@28" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "openssl@4"

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
