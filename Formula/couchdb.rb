class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.2.2/apache-couchdb-3.2.2.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.2.2/apache-couchdb-3.2.2.tar.gz"
  sha256 "69c9fd6f80133557f68a02e92dda72a4fd646d646f429f45bb8329a30f82f20e"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?apache-couchdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "10915b592f151923cfdbb897fdfce09472428acf706c47270be15bbb7e03519d"
    sha256 cellar: :any,                 arm64_big_sur:  "2fa3cd31dc3c53a80f389cca0cfcb01e6437f5769fd016af407e71a07454b5f6"
    sha256 cellar: :any,                 monterey:       "f62c2ccecaadc5de7caccd62d4f4500afebca0dc69d8d4d2dbe0b7ad5d68bd1e"
    sha256 cellar: :any,                 big_sur:        "5f927c75898000afb985bd0574ac155869f1348fe018fc0b7c15ba4ae3950de5"
    sha256 cellar: :any,                 catalina:       "ace6e1b4a44b08522fc49bfa65e194502a886fec1c0d5a8edad890eee43ecc3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af86b0a02aec04ac0b6d33027b4056ac3dad0794c1bdae9485c67626363ca5ed"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  # Use Erlang 24 to work around a sporadic build error with rebar (v2) and Erlang 25.
  # beam/beam_load.c(551): Error loading function rebar:save_options/2: op put_tuple u x:
  #   please re-compile this module with an Erlang/OTP 25 compiler
  # escript: exception error: undefined function rebar:main/1
  # Ref: https://github.com/Homebrew/homebrew-core/pull/105876
  depends_on "erlang@24" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@3"
  # NOTE: Supported `spidermonkey` versions are hardcoded at
  # https://github.com/apache/couchdb/blob/#{version}/src/couch/rebar.config.script
  depends_on "spidermonkey"

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  fails_with :gcc do
    version "5"
    cause "mfbt (and Gecko) require at least gcc 6.1 to build."
  end

  def install
    spidermonkey = Formula["spidermonkey"]
    inreplace "src/couch/rebar.config.script" do |s|
      s.gsub! "-I/usr/local/include/mozjs", "-I#{spidermonkey.opt_include}/mozjs"
      s.gsub! "-L/usr/local/lib", "-L#{spidermonkey.opt_lib} -L#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "--spidermonkey-version", spidermonkey.version.major
    system "make", "release"
    # setting new database dir
    inreplace "rel/couchdb/etc/default.ini", "./data", "#{var}/couchdb/data"
    # remove windows startup script
    rm_rf("rel/couchdb/bin/couchdb.cmd")
    # install files
    prefix.install Dir["rel/couchdb/*"]
    if File.exist?(prefix/"Library/LaunchDaemons/org.apache.couchdb.plist")
      (prefix/"Library/LaunchDaemons/org.apache.couchdb.plist").delete
    end
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
