class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.2.1/apache-couchdb-3.2.1.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.2.1/apache-couchdb-3.2.1.tar.gz"
  sha256 "11de2d1c3a5b317017a7459ec3f76230d5c43aba427a1e71ca3437845874acf8"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?apache-couchdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "bd42975d1094c79bd8fd085267e920c7aa60b1271512c286ed3d0081073b9a79"
    sha256 cellar: :any,                 big_sur:      "0e88d8d596cb77003f76a0a2962327ddfe79b150c137698c29dc3d1a5c6bc526"
    sha256 cellar: :any,                 catalina:     "e1227886bab7e206f51afaea3d4ddf58f07bc491f4df3ba5fe152c5246a36be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7d855bb5a722a550d8a4e7a9d9f711f9c306c790948af8ef9d39e7bf2527b334"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang@22" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"
  # NOTE: Check for supported `spidermonkey` versions when updating at
  # https://github.com/apache/couchdb/blob/#{version}/src/couch/rebar.config.script
  depends_on "spidermonkey@78"

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  fails_with :gcc do
    version "5"
    cause "mfbt (and Gecko) require at least gcc 6.1 to build."
  end

  def install
    spidermonkey = Formula["spidermonkey@78"]
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
