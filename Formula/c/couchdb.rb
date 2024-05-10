class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  # TODO: Check if we can use unversioned `erlang` at version bump.
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.3.3/apache-couchdb-3.3.3.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.3.3/apache-couchdb-3.3.3.tar.gz"
  sha256 "7a2007b5f673d4be22a25c9a111d9066919d872ddb9135a7dcec0122299bd39e"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d58fc777fa9ff9f6de43919dfa9c024d5ce850b71f2ca085b6168375ffbfdd80"
    sha256 cellar: :any,                 arm64_ventura:  "82fd98b83ab7a1e703036c448d49b79b0d39e52656905b909e4ba75f043cb452"
    sha256 cellar: :any,                 arm64_monterey: "efcb725d281accb0b97617543a9a0deade589ad9fa9e44b00a7a718f732f96ee"
    sha256 cellar: :any,                 sonoma:         "be25994ef1cdc49419c6d00876e60aa1c8ae0b4fa457081d399511b2d8d66d46"
    sha256 cellar: :any,                 ventura:        "cc8e6a16e23b87de62056a8a2bb1a789c9dbc188afb41f9c2040b1799afca213"
    sha256 cellar: :any,                 monterey:       "ce55bb241a7956e8fd171eb3300bbb5e30a2e9041bc04fab07ceffaab73c3a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a5418e235e9d12abab2ddba6059466bb49bdcaed44cc30ef0c68a5f8322496"
  end

  # Can undeprecate if:
  # * QuickJS support is added: https://github.com/apache/couchdb/issues/4448
  # * Spidermonkey 115 support is added
  #
  # Issue ref: https://github.com/apache/couchdb/issues/4825
  deprecate! date: "2024-02-22", because: "uses deprecated `spidermonkey@91`"

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
  depends_on "spidermonkey@91"

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  fails_with :gcc do
    version "5"
    cause "mfbt (and Gecko) require at least gcc 6.1 to build."
  end

  def install
    spidermonkey = Formula["spidermonkey@91"]
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
