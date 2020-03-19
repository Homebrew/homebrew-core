class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://downloads.mariadb.org/connector-odbc/"
  url "https://downloads.mariadb.org/f/connector-odbc-3.1.6/mariadb-connector-odbc-3.1.6-ga-src.tar.gz"
  sha256 "fbad8430cc728609f4c6b0aac5acb27d0b0a1315be45fb697f9e16919b3cbb71"

  bottle do
    cellar :any
    sha256 "5fd19dc3d304d20bfe9c20e57880eb07d5a687206c3ac02828bb6dc42f29b2a0" => :catalina
    sha256 "31c692b9b55d557f35c9d543b8ff9d40bc1b7e251d03de00f0797cadb2d9cd9f" => :mojave
    sha256 "641e2bd8da691dfa203fa925a3d89feaca715d724bd4cf75323b76a0675b1828" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "mariadb-connector-c"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  def install
    ENV.append_to_cflags "-I#{Formula["mariadb-connector-c"].opt_include}/mariadb"
    ENV.append "LDFLAGS", "-L#{Formula["mariadb-connector-c"].opt_lib}/mariadb"
    system "cmake", ".", "-DMARIADB_LINK_DYNAMIC=1",
                         "-DWITH_SSL=OPENSSL",
                         "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                         "-DWITH_IODBC=0",
                         *std_cmake_args

    # By default, the installer pkg is built - we don't want that.
    # maodbc limits the build to just the connector itself.
    # install/fast prevents an "all" build being invoked that a regular "install" would do.
    system "make", "maodbc"
    system "make", "install/fast"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libmaodbc.dylib")
    assert_equal "SUCCESS: Loaded #{lib}/libmaodbc.dylib", output.chomp
  end
end
