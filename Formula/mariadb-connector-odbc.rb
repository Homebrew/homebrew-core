class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://downloads.mariadb.com/Connectors/odbc/connector-odbc-3.1.17/mariadb-connector-odbc-3.1.17-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.1.17-src.tar.gz/"
  sha256 "d2eb92f1dd3eecc6e721a8172b6455afef77505a344a3d5e260ee2f7a02a6efc"
  license "LGPL-2.1-or-later"

  # https://mariadb.org/download/ sometimes lists an older version as newest,
  # so we check the JSON data used to populate the mariadb.com downloads page
  # (which lists GA releases).
  livecheck do
    url "https://mariadb.com/downloads_data.json"
    regex(/href=.*?mariadb-connector-odbc[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "08853d5451e38d4ce3fce2fb82c16aef9f62c631809e624a1bbc838b9ec487f2"
    sha256 cellar: :any,                 arm64_monterey: "43ab18291966567ecf2143c2c91ee62b8aea0eb5a8bf4ed3592b8a5806677649"
    sha256 cellar: :any,                 arm64_big_sur:  "3babd69105257498323fc75469548c3666ec1b31d5f4d45b983089a7be8a10ad"
    sha256 cellar: :any,                 ventura:        "38b1eadff01b92d066834bc6c524e68e7cf42f20b123223508fe350b28fede97"
    sha256 cellar: :any,                 monterey:       "2ee7edcaa3603bfb82fd570b5308b0a21c29c5d31ff568b1bb9b16c8164f40c0"
    sha256 cellar: :any,                 big_sur:        "b475ebd8a0bb291256a23d3b446c1027e0f859ef9263a46bfac54140f502634f"
    sha256 cellar: :any,                 catalina:       "2856699f88e3502d2055e7f2f7db4955e542fde5dcab7c5b1e0f8de1c38fa33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d6c9974a94f8366c0c515d23f951c7890906d716bf3e33f4495d59cec17541b"
  end

  depends_on "cmake" => :build
  depends_on "mariadb-connector-c"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  def install
    ENV.append_to_cflags "-I#{Formula["mariadb-connector-c"].opt_include}/mariadb"
    ENV.append "LDFLAGS", "-L#{Formula["mariadb-connector-c"].opt_lib}/mariadb"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["mariadb-connector-c"].opt_lib}/mariadb" if OS.linux?
    system "cmake", ".", "-DMARIADB_LINK_DYNAMIC=1",
                         "-DWITH_SSL=OPENSSL",
                         "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                         "-DWITH_IODBC=0",
                         # Workaround 3.1.11 issues finding system's built-in -liconv
                         # See https://jira.mariadb.org/browse/ODBC-299
                         "-DICONV_LIBRARIES=#{MacOS.sdk_path}/usr/lib/libiconv.tbd",
                         "-DICONV_INCLUDE_DIR=/usr/include",
                         *std_cmake_args

    # By default, the installer pkg is built - we don't want that.
    # maodbc limits the build to just the connector itself.
    # install/fast prevents an "all" build being invoked that a regular "install" would do.
    system "make", "maodbc"
    system "make", "install/fast"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/mariadb/#{shared_library("libmaodbc")}")
    assert_equal "SUCCESS: Loaded #{lib}/mariadb/#{shared_library("libmaodbc")}", output.chomp
  end
end
