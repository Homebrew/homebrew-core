class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://downloads.mariadb.com/Connectors/odbc/connector-odbc-3.1.16/mariadb-connector-odbc-3.1.16-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.1.16-src.tar.gz/"
  sha256 "4fd0de9d0e9da883ac9801cbf97953be9cc9010830417c44e8b339deca48463d"
  license "LGPL-2.1-or-later"

  # https://mariadb.org/download/ sometimes lists an older version as newest,
  # so we check the JSON data used to populate the mariadb.com downloads page
  # (which lists GA releases).
  livecheck do
    url "https://mariadb.com/downloads_data.json"
    regex(/href=.*?mariadb-connector-odbc[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b42f1ff1129c849ac5cbba73424266fc19f3a3f6e17e08553e5e42a5acdb4325"
    sha256 cellar: :any,                 arm64_big_sur:  "bfaba599e5ffe9b9012514a7da54d632d757f2bcec7f2deaefce2a8dee7231e8"
    sha256 cellar: :any,                 monterey:       "417e39a2ed3e66fdee7263addcdc610d8c3cf440ffae2b03f2301a62fa8dff97"
    sha256 cellar: :any,                 big_sur:        "0adf308c6438698c03832df3b4972e1007b39a76b29edf835e7f8fdd59065cb6"
    sha256 cellar: :any,                 catalina:       "ba65e8cb114ebcd3ffa3680a24198e8c0e03a87d8f209cfae67505eb1aa6d6ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "703ad542557eedfe66091ff91c06279c1a4fcf7a77f045c6b3661b5c902652a1"
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
