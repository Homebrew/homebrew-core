class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.2.1/apache-couchdb-3.2.1.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.2.1/apache-couchdb-3.2.1.tar.gz"
  sha256 "11de2d1c3a5b317017a7459ec3f76230d5c43aba427a1e71ca3437845874acf8"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?apache-couchdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "11ba7ea770ea7359365e9e4beb0460dc0380e8987daa770298007eedd8bbee97"
    sha256 cellar: :any,                 arm64_big_sur:  "c07a1521fc8fd0604f591f0b66521ee13cd1e4950962b34adbb73ea0963937ad"
    sha256 cellar: :any,                 monterey:       "4c87b357fbda61414e199e63836cc71550385b287a75693fa8abeb87af2056e3"
    sha256 cellar: :any,                 big_sur:        "39891fec49abfd7ff6fbc78f0e3ecc5ddb34511be02dc4bdf76e0661dda2779d"
    sha256 cellar: :any,                 catalina:       "db22c5a177fa73c0180b95920a99000a0a257dcd55a2fe1544fd7215fa3b4b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "939c7c053656690df36b7c2ad9d19cda20154caad4ac16acaa2a1a7eab58b92e"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang@22" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"
  # NOTE: Supported `spidermonkey` versions are hardcoded at
  # https://github.com/apache/couchdb/blob/#{version}/src/couch/rebar.config.script
  depends_on "spidermonkey"

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  fails_with :gcc do
    version "5"
    cause "mfbt (and Gecko) require at least gcc 6.1 to build."
  end

  # Add support for SpiderMonkey 91esr. Remove in the next release.
  # PR ref: https://github.com/apache/couchdb/pull/3842
  patch do
    url "https://github.com/apache/couchdb/commit/cb6aff46b65b68fd48293971a11c29633a0e21ff.patch?full_index=1"
    sha256 "c32bc73937dd598cfc433a44098823e069665e6c85e8ec24f6da2ba56b42b02a"
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
    File.delete("rel/couchdb/bin/couchdb.cmd") if File.exist?("rel/couchdb/bin/couchdb.cmd")
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
