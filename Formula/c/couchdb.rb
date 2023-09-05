class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
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
    sha256 cellar: :any,                 arm64_ventura:  "b44aacdf280a2f3c2f3af38a7f70085e235f054603da579defd71fc254fb2acc"
    sha256 cellar: :any,                 arm64_monterey: "4410e98100842db4c70040e0fe36b024f4c2f84aa56a218e026f081ae85dcb21"
    sha256 cellar: :any,                 arm64_big_sur:  "f9ec695c49e2b460bf6ce4f65202c2f55f420dcfb2123ba4f6ef8c6c84aa1130"
    sha256 cellar: :any,                 ventura:        "ef789cc239ffcd25bb447f0292c7687b7edd391df336e8c0e3999a735cc8ca35"
    sha256 cellar: :any,                 monterey:       "207ce0c943397c513a8b8a213a723278c32d07769879ce4efadc792dac4c0c5f"
    sha256 cellar: :any,                 big_sur:        "c9c10e39919268530595ca4d5d6597527782319c7b50897b4422ce6dae0a2ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7aa15ebf83c32e0cdfdaf44aa9151cec5a170462f4a999f4bd00f2b131e959d"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  # Use Erlang 24 to work around a sporadic build error with rebar (v2) and Erlang 25.
  # beam/beam_load.c(551): Error loading function rebar:save_options/2: op put_tuple u x:
  #   please re-compile this module with an Erlang/OTP 25 compiler
  # escript: exception error: undefined function rebar:main/1
  # Ref: https://github.com/Homebrew/homebrew-core/pull/105876
  depends_on "erlang" => :build
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
