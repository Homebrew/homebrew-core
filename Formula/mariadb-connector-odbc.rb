class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://downloads.mariadb.org/connector-odbc/"
  url "https://downloads.mariadb.org/f/connector-odbc-3.1.13/mariadb-connector-odbc-3.1.13-src.tar.gz"
  sha256 "29aa6b8b49971050b341be86f5e130d126c4c296d965aaa6a1559745164b82aa"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/Download (\d+(?:\.\d+)+) Stable Now!/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "04c23fb24dccd630e781a6b2ad2f90b24c81cb245eb06070d78f7d61674277ee"
    sha256 cellar: :any, big_sur:       "b9bfe9c9818674735b07303ff5be62a0dba92fe7e257c242978b8f90fcf86858"
    sha256 cellar: :any, catalina:      "5b0a11482f81ce2baf03e12c1ab5dae45294e889f39738e103bb44791ec2b20e"
    sha256 cellar: :any, mojave:        "eaf378dc4748d4515bf3f1f73c2b501d8b5b4eba7952ed0ecff1c27ee542bbdb"
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
