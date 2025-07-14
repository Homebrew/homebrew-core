class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.5.0/apache-couchdb-3.5.0.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.5.0/apache-couchdb-3.5.0.tar.gz"
  sha256 "6a98b90a9a980bbef2c35b4996a8e71a2f1ae5227546c85f04c436101bdf78bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "494834ac7eb89abaa626f40da8e36d66d1baa25208461e4291ee8b137a966046"
    sha256 cellar: :any,                 arm64_sonoma:  "a2bc0d8e0b255d86fcf372d4018c9f93e9b3c7edc909b6c620eb29d3a24a8076"
    sha256 cellar: :any,                 arm64_ventura: "330edda7ac863727ff503967b804b4478b56ed77da7bdf224e003f170e079233"
    sha256 cellar: :any,                 sonoma:        "d20b7f7a61e7ee14a2cf4bf79c6c2ab9a0bd04e87b1c9b21caec8960ec2eef5b"
    sha256 cellar: :any,                 ventura:       "caf1090e2e3afa205a16fd65a7eaf2648b357345485f33b2d739398f9d0ac6bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f7686fac2918b759cf2b144a4bab228da34dbd4b6562ce8a615b68634cc9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6950b0cef1186e7176df89242bab15c8840cae22df96f1adbbef0f18cf6c4b78"
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
