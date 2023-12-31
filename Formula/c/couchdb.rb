class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  # TODO: Check if we can use unversioned `erlang` at version bump.
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.3.3/apache-couchdb-3.3.3.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.3.3/apache-couchdb-3.3.3.tar.gz"
  sha256 "7a2007b5f673d4be22a25c9a111d9066919d872ddb9135a7dcec0122299bd39e"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?apache-couchdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c62f82f36ed6e06e72bf02b809f23b4c5990c10f13ffe33a19c21dddbad3ff3c"
    sha256 cellar: :any,                 arm64_ventura:  "31355e449ecb31c2af664b4c4d66402bfd8c568fefdab7ecbea28bcf49eefcbf"
    sha256 cellar: :any,                 arm64_monterey: "7235967b0d2c319102055b1d473d6990f727227119641a23d4c5485611d6382f"
    sha256 cellar: :any,                 sonoma:         "dc24bc6c4058fbf39a4d066a7c095045b881e189005b2efebcc5190c50386775"
    sha256 cellar: :any,                 ventura:        "a2b506cfb131f2504f8f4c200ab6b41f740f0abe183184a34606cd96027b8aa2"
    sha256 cellar: :any,                 monterey:       "e0511d28914934e1446cb8dff30b55cbac4f900d8b3ccd8eaf686b6bb243864f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cc21bd0a47af081af2aa8a03a0f67d029f8e79f18a137dfaee422601a5c21c0"
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
