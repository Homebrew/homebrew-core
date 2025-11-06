class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.5.0/apache-couchdb-3.5.0.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.5.0/apache-couchdb-3.5.0.tar.gz"
  sha256 "6a98b90a9a980bbef2c35b4996a8e71a2f1ae5227546c85f04c436101bdf78bf"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8b59edba04e1dbe3872be868ae197372c7883037f4214b6e5629b5066721c25"
    sha256 cellar: :any,                 arm64_sequoia: "927494b62d7382adec8185eb6f306b0ef99b482c3daefb681beeee0a664bc2a7"
    sha256 cellar: :any,                 arm64_sonoma:  "e0d413083fa0704df0d9656672aee2ce4e4efb9cb659dd6d6ac04bdc3343fae7"
    sha256 cellar: :any,                 sonoma:        "9a5a2346845a54281ffc0b1899fd91dbca43dc2c45824bb6760002a3b2914d9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a44ac0926c11ff836f54e6903813cf88ef2b5dcfd9d021c29f9a71728326fd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "195a9ab08f8bc03c3f7d329be1c1fbfc09211c6baba4f4c10fc879a344ed027b"
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
