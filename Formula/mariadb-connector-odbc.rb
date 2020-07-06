class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://downloads.mariadb.org/connector-odbc/"
  url "https://downloads.mariadb.org/f/connector-odbc-3.1.7/mariadb-connector-odbc-3.1.7-ga-src.tar.gz"
  sha256 "699c575e169d770ccfae1c1e776aa7725d849046476bf6579d292c89e8c8593e"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "98bfc0e11134fa8958aa38810c9c16eb12bda27f4b319ebf8cb218845bec7a89" => :catalina
    sha256 "28fb8b7089115c8be14b968ab3a604f2a3c2642a8592272bc4caf3812b6e25ba" => :mojave
    sha256 "84ddb76363d80231117b6a026e1371463478e5d8d15733c0ba786e141c3b8667" => :high_sierra
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
