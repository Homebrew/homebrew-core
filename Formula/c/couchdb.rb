class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.4.1/apache-couchdb-3.4.1.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.4.1/apache-couchdb-3.4.1.tar.gz"
  sha256 "aaacea1bd66cf641fd8198dce662a337b359b69d8fd4737e3b0e306b549c3fe5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "24da382c88e41fc5a3570380393262d1b7745ff7edb979a2bcc963630ea8aea1"
    sha256 cellar: :any,                 arm64_sonoma:  "737b0d6bb26aba33c7c16081c3145d1890ed25d2405b7da7ae7c0d553b4bab1f"
    sha256 cellar: :any,                 arm64_ventura: "8f3e65846d0ce95f01862ca798b8c4c1c51ce54b36ed8118673aeadba2f963a5"
    sha256 cellar: :any,                 sonoma:        "a69fc76df6cae36cf89033c596056f07c5c06d0a41e472bfa4e0b3d1230d9563"
    sha256 cellar: :any,                 ventura:       "52df41abe499df5fbd63b6a17958cb3a89ce6b07e9b48f2c24df0bff03e869b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38e256eb59833dd06ce576063686c84b55eb4d9c6dd6e5d5db2c268c10dfa49"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  fails_with :gcc do
    version "5"
    cause "mfbt (and Gecko) require at least gcc 6.1 to build."
  end

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
