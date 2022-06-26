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
    sha256 cellar: :any,                 arm64_monterey: "8f131dc3b8b13deccd6baeffcee14be1b37b53602710efe33a7ddf76931b7915"
    sha256 cellar: :any,                 arm64_big_sur:  "b7956f4278576bf4b74acb559977613cc93c4884ee5829b26b13aa23cebdbb0f"
    sha256 cellar: :any,                 monterey:       "e24bda353b712cb258fa674aa7f54ebf70505b1f9166d90016655aeadfad7b60"
    sha256 cellar: :any,                 big_sur:        "eba70e593f88cc84a19eda28962b61c8ba1d0ff6bb2d4c685c18e4ce5ad94e34"
    sha256 cellar: :any,                 catalina:       "6a039b50da6d6dc5f6122fb9f8f396e14e4466029115130f946106e3f4643e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e59246b54882e965ac4b067e1b942d9180dc9e7c5ede461abd30e473b3d86b2a"
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
