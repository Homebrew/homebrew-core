class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.4.3/apache-couchdb-3.4.3.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.4.3/apache-couchdb-3.4.3.tar.gz"
  sha256 "0357511b6fed70e3e64f4e75aa5d7cc2000cb0f264ef301702b1816427f72f20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e523011eea3b22172feb254072a28c8ca073d18816c60c90a5b9bb5eba1d66d5"
    sha256 cellar: :any,                 arm64_sonoma:  "7b24890f9d483d21b827da7e999d2ff0d8b72123ef19e06a7eeaeb0ebae62565"
    sha256 cellar: :any,                 arm64_ventura: "a5fda03cc86a01e22957ac602e14e6c80f35d944f966574e246770666aab7eec"
    sha256 cellar: :any,                 sonoma:        "b4d4bd31011ec25fe363e19b8283334d539f484657109d59e3b0d64ab384db54"
    sha256 cellar: :any,                 ventura:       "2a3f22dc854e999240438bee07c370b7a567b0ed27361da7770ee86c485cd92a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5704eb3de5c13291e627cd647f1e5b2fa41cc760b4d9daae497dfd5b9c67d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59f05ef6aa4da41b497c2aad008acdb68ee9d8319c73951ce69cbd1f03ee17c7"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
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
