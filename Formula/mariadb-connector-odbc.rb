class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://downloads.mariadb.com/Connectors/odbc/connector-odbc-3.1.18/mariadb-connector-odbc-3.1.18-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.1.18-src.tar.gz/"
  sha256 "a06c11b40cf1edcfe69c206eec32caf58e25fadcf53da63d65fae26437bbad7e"
  license "LGPL-2.1-or-later"

  # https://mariadb.org/download/ sometimes lists an older version as newest,
  # so we check the JSON data used to populate the mariadb.com downloads page
  # (which lists GA releases).
  livecheck do
    url "https://mariadb.com/downloads_data.json"
    regex(/href=.*?mariadb-connector-odbc[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "14949a62da2a2ce7d2cd7aefec31138f8dd125130d4bfce4a24535e69a275a7f"
    sha256 cellar: :any,                 arm64_monterey: "c98c4467ae397029d3436af6c8ae9758ae84af8248eda33abcccb2b4bd769b82"
    sha256 cellar: :any,                 arm64_big_sur:  "d212b429637cf77c8a8c4da0d781ce9e27c216920c2e8e4e12e96437ec3dbbd9"
    sha256 cellar: :any,                 ventura:        "dd3909020b76536e2a6fc28d6bca781dada59294758c801dc90268c1423e5d38"
    sha256 cellar: :any,                 monterey:       "4831fc2816c02814ba217c49e428c41c538599dc58cd033eb32bfee72f1998fe"
    sha256 cellar: :any,                 big_sur:        "fcd4a3e2dce3d5b40450b99e6e56576d7268ae8aa0c7c631fc65f9b507b96d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f10dcafbc59db923b25057cb0294ca7b1a071ffd8f2ef81752027c849da8ab9"
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
