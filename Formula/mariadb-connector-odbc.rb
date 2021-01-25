class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://downloads.mariadb.org/connector-odbc/"
  url "https://downloads.mariadb.org/f/connector-odbc-3.1.11/mariadb-connector-odbc-3.1.11-ga-src.tar.gz"
  sha256 "d81a35cd9c9d2e1e732b7bd9ee704eb83775ed74bcc38d6cd5d367a3fc525a34"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/Download (\d+(?:\.\d+)+) Stable Now!/i)
  end

  bottle do
    sha256 "8ecf2575cfb6897176626d13821da084b97a86fff29103f21a6122fb508234c6" => :big_sur
    sha256 "14eab02c927c39019801250936766b9f913ccee3ce1ebc0a10d87753ec46e5c3" => :arm64_big_sur
    sha256 "9e026906501acc48c754a22cd3415f968121d378d9b23ae02d09a92e771634b9" => :catalina
    sha256 "7291bc304b018ed6f5b9edbc5dcc35de99135be517eb559217148ae3f9d333c2" => :mojave
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
