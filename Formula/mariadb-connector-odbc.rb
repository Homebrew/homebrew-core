class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://downloads.mariadb.org/connector-odbc/"
  url "https://downloads.mariadb.org/f/connector-odbc-3.1.6/mariadb-connector-odbc-3.1.6-ga-src.tar.gz"
  sha256 "fbad8430cc728609f4c6b0aac5acb27d0b0a1315be45fb697f9e16919b3cbb71"

  bottle do
    cellar :any
    sha256 "d5345b3a38f7fc8d7828981e498615a2d57a9901d281c1df118c3884e85108de" => :catalina
    sha256 "b960e6ea642b098ef7cbe7b834d132ac8a5710cc81e8caa2b7223ce3436cabe2" => :mojave
    sha256 "b07194158ff198b5386768679975367af20a32b01ad87c90302e1c959eb4d374" => :high_sierra
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
