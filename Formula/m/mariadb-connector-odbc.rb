class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://archive.mariadb.org/connector-odbc-3.1.19/mariadb-connector-odbc-3.1.19-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.1.19-src.tar.gz/"
  sha256 "26420dac7d6d630fc34fb2fe77fdc9fc2a7e8e896d274d3c052db9ecd06bd48f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://downloads.mariadb.org/rest-api/connector-odbc/all-releases/?olderReleases=false"
    strategy :json do |json|
      json["releases"]&.map do |release|
        next if release["status"] != "stable"

        release["release_number"]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "584f054978da3cfb641a9504c4eb4ca19463f9a23c16b81714b210900dead39d"
    sha256 cellar: :any,                 arm64_monterey: "21ef52b7656d91d41439996035a56aaaeb6650453bcbfd5a6e97c8020e8f03d3"
    sha256 cellar: :any,                 arm64_big_sur:  "1476558de12837abd0307c1b55e920c421330d2a6b546260d00c86837ee1a3c6"
    sha256 cellar: :any,                 ventura:        "8bed3cbed522f3c18755aba7ea46a872f73643c4f88d43fcc8f5992a0751f13c"
    sha256 cellar: :any,                 monterey:       "1f7b12bf36787f8335ea55a5f3a10bd0dce9bb402adb23be9a6db164ba4cd977"
    sha256 cellar: :any,                 big_sur:        "44a4dc52e2610f658964f73e69c3093dde7b39fdc51086ce2a4799741044142b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "011b218c61c1b204fb17be5277ea294257b93d729e0fead1d84059dbc0f95b1f"
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
                         "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
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
