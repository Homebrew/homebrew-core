class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.5.2/apache-couchdb-3.5.2.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.5.2/apache-couchdb-3.5.2.tar.gz"
  sha256 "e561102aaadfdda1e499e6e9e12d2473433291b608bcd390bcbcf590bbb6cf68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c761837cd3353216247fadfed573ee038b85cfe46ee408cff9af03aeb157dca"
    sha256 cellar: :any,                 arm64_sequoia: "5badcd04342cc9a37fb663df101507e843d95351491e733ad115f910f45a3151"
    sha256 cellar: :any,                 arm64_sonoma:  "41efc1c44250b5f77c5eb171fc4b804c4acf3d3325335dadf34a75e7d7731327"
    sha256 cellar: :any,                 sonoma:        "b6a0e5d0505f3a95a72bc98abf156fdd6106d751c60aaeebe21d0e7daf433e5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1822285fbcd099f14be030fe83db52b25925ef34009c7f30c099292c879c5f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8cf1650ee1cf1dfb1abcdd456552ebb1b1764cbbd55b6e8600d6ad836802949"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang@28" => :build
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
