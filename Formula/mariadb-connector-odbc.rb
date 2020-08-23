class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://downloads.mariadb.org/connector-odbc/"
  url "https://downloads.mariadb.org/f/connector-odbc-3.1.9/mariadb-connector-odbc-3.1.9-ga-src.tar.gz"
  sha256 "5ead3f69ccde539fd7e3de6f4b8f0e6f9f6c32b4b4f082adf0e2ff110971fe1e"
  license "LGPL-2.1"

  bottle do
    sha256 "339b4c5fa7121936bd5ed68e5d6c507400e43445bc46b63f6cea6212e047c66f" => :catalina
    sha256 "4ba2a2852289ab5843bba747e84188d0c663d39129be4bb57ef23307ffc93261" => :mojave
    sha256 "49f91ee3450c6650885b90efa9c07ca5d23f72fdd8a37387302cdf5c0ad548a9" => :high_sierra
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
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/mariadb/libmaodbc.dylib")
    assert_equal "SUCCESS: Loaded #{lib}/mariadb/libmaodbc.dylib", output.chomp
  end
end
