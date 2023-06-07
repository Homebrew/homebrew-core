class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.3.2/apache-couchdb-3.3.2.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.3.2/apache-couchdb-3.3.2.tar.gz"
  sha256 "3d6823d42d10cf0d4f86c9c4fe59c9932c89d68578fcb6c4b4278dc769308daa"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?apache-couchdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7240d01a29421200bfc00098b15bd0a63b301c81debb0c12e8ecbeba3d9ebbd8"
    sha256 cellar: :any,                 arm64_monterey: "d1144b4e5ef64034717d52c8ed6950fa08ab0e1ee3e12526506f3ee13ae40c8c"
    sha256 cellar: :any,                 arm64_big_sur:  "cae204003d6da3ae5c15dc00c0e550aa0132d822c6bd55465750f69bb258e43b"
    sha256 cellar: :any,                 ventura:        "dcbe1a4a7067a7fa8ae1d79d98c3808d7756e7adf450cc09b3b259b18e339a8e"
    sha256 cellar: :any,                 monterey:       "7fb19cc25032cd14f0a4e029cc9fbf976e9513a8f354dfc09881e41b495ccc8f"
    sha256 cellar: :any,                 big_sur:        "447f8389a931483b03fe00fbec4074f39233d15b7836178d67241d275afed9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d4d0407c3a8be157cfa0d0cbb35835de99d309d29f33b2086a2113300b1a7f8"
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
  depends_on "openssl@1.1"
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
