class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://downloads.mariadb.org/connector-odbc/"
  url "https://downloads.mariadb.org/f/connector-odbc-3.0.2/mariadb-connector-odbc-3.0.2-ga-src.tar.gz"
  mirror "http://archive.mariadb.org/connector-odbc-3.0.2/mariadb-connector-odbc-3.0.2-ga-src.tar.gz"
  sha256 "eba4fbda21ae9d50c94d2cd152f0ec14dde3989522f41ef7d22aa0948882ff93"
  revision 1

  bottle do
    sha256 "931fc3d945d3b431944d4efc88558b9cb161860ba4c0bcb2e9ed7d5c57a92eed" => :mojave
    sha256 "c9f38fdfe0cc72c8e752ef232201b4b50f587bf587dd748fce4acb5c0724330d" => :high_sierra
    sha256 "e87b4cff0c23a18b93df69748d04fab4e2e04a38a39f9fdefbe72c556f3d5cfe" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "mariadb-connector-c"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  def install
    system "cmake", ".", "-DMARIADB_FOUND=1",
                         "-DWITH_OPENSSL=1",
                         "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl@1.1"].opt_include}",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libmaodbc.dylib")
    assert_equal "SUCCESS: Loaded #{lib}/libmaodbc.dylib", output.chomp
  end
end
