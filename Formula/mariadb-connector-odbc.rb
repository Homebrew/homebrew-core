class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://downloads.mariadb.org/connector-odbc/"
  url "https://downloads.mariadb.org/f/connector-odbc-3.1.5/mariadb-connector-odbc-3.1.5-ga-src.tar.gz"
  sha256 "c5a96fa166c8e7c93ceb86eeef2b4f726e076329f7686e36f7044e7b23b44ea9"

  bottle do
    sha256 "1c830919c8e1db83042f7cab13e21c8a09bdc754ae1acb2374eaa6ed75ce7267" => :catalina
    sha256 "931fc3d945d3b431944d4efc88558b9cb161860ba4c0bcb2e9ed7d5c57a92eed" => :mojave
    sha256 "c9f38fdfe0cc72c8e752ef232201b4b50f587bf587dd748fce4acb5c0724330d" => :high_sierra
    sha256 "e87b4cff0c23a18b93df69748d04fab4e2e04a38a39f9fdefbe72c556f3d5cfe" => :sierra
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
