class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  # TODO: Check if we can use unversioned `erlang` at version bump.
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.3.2/apache-couchdb-3.3.2.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.3.2/apache-couchdb-3.3.2.tar.gz"
  sha256 "3d6823d42d10cf0d4f86c9c4fe59c9932c89d68578fcb6c4b4278dc769308daa"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?apache-couchdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d6a47ac0fb58267e64699d8115e19f98bc2174c05786960468ece30414910a7c"
    sha256 cellar: :any,                 arm64_monterey: "94387865d1659a2e0587894e785ee2b7416c0cfaa7fa32d869d5ab9427fe1d39"
    sha256 cellar: :any,                 ventura:        "b641d0f8d05406c8493855a4d8129407374466ebaa1ce0125ac0c818f56e29a6"
    sha256 cellar: :any,                 monterey:       "8b3f31e9ef0ff3ffc87e2e9c16dfe535aa6fc30ef07635a896a7c2166d460fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88579949ac1064d63ffa9ad518bf69df2ce2e123ef830b1637dd1ba037dfddc1"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang@25" => :build
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
    inreplace "configure", '[ ! -d "/usr/local/include/${SM_HEADERS}" ]',
                           "[ ! -d \"#{spidermonkey.opt_include}/${SM_HEADERS}\" ]"
    inreplace "src/couch/rebar.config.script" do |s|
      s.gsub! "-I/usr/local/include/mozjs", "-I#{spidermonkey.opt_include}/mozjs"
      s.gsub! "-L/usr/local/lib", "-L#{spidermonkey.opt_lib} -L#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "--spidermonkey-version", spidermonkey.version.major.to_s
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
