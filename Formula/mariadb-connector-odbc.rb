class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://downloads.mariadb.com/Connectors/odbc/connector-odbc-3.1.18/mariadb-connector-odbc-3.1.18-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.1.18-src.tar.gz/"
  sha256 "a06c11b40cf1edcfe69c206eec32caf58e25fadcf53da63d65fae26437bbad7e"
  license "LGPL-2.1-or-later"
  revision 1

  # https://mariadb.org/download/ sometimes lists an older version as newest,
  # so we check the JSON data used to populate the mariadb.com downloads page
  # (which lists GA releases).
  livecheck do
    url "https://mariadb.com/downloads_data.json"
    regex(/href=.*?mariadb-connector-odbc[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e1a335fbec0b838a2c367aa492ea737cc74821d115dec421aa880c983366dd97"
    sha256 cellar: :any,                 arm64_monterey: "31b055622f6590924da20bb79343778f91fa64f813cb7c26e4b63b5986a23034"
    sha256 cellar: :any,                 arm64_big_sur:  "eeab98e0fdb458bf0d89e1a6eee6c12624f7636f79cbecb98146ea892dc91bc1"
    sha256 cellar: :any,                 ventura:        "132d4a20a5d33990f63eac81603d0b4802fe7d98e75f5424dd075ad18b092e82"
    sha256 cellar: :any,                 monterey:       "d5c0e36c8e084eefd289c9bf0f74d98b9af176ecf38deacb71eb4a5139eeb170"
    sha256 cellar: :any,                 big_sur:        "3fbaa5c55258ebe0dcd2a15e3f8163a16b5f06f3d5a0e66f7d040c8304625f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad93cc1ce064a3d6674051901c4f76b70df6917094b6fd972871e360eab1ba10"
  end

  depends_on "cmake" => :build
  depends_on "mariadb-connector-c"
  depends_on "openssl@3"
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
