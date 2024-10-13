class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://archive.mariadb.org/connector-odbc-3.2.3/mariadb-connector-odbc-3.2.3-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.2.3-src.tar.gz/"
  sha256 "a2925063f0eefa5258cafe1a8bbec1582a0ea5ca43e7a78496b150fa1c021b62"
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
    sha256 cellar: :any,                 arm64_sequoia:  "e451b4ce3119559b5436860e1649ffa9eb80851381f0ad0da95d1e0180852e30"
    sha256 cellar: :any,                 arm64_sonoma:   "e5d37bb151f2ad25df7aef0a05c3b8fbb5dc97dee43f606d79355566da438e4f"
    sha256 cellar: :any,                 arm64_ventura:  "35ef2093432b4f6ddfe26b0c8be57623d93eea20ebe4341cd6ec8bbe90f50202"
    sha256 cellar: :any,                 arm64_monterey: "3489843ff83be733e03746537a9096356cbbb7c99746fb5c9ff387c2b95444d2"
    sha256 cellar: :any,                 sonoma:         "3e081e1b8b61bea4ddf51636db0e09e030bddb7d6b2a0dae98bffa10515ca71e"
    sha256 cellar: :any,                 ventura:        "3ee0199b3e161b08ed49bf7918fe326dbaff985387f0a5bb2bf6bc5f7ad189f1"
    sha256 cellar: :any,                 monterey:       "af73a0411bb3b404fb41e8aaea4dae80fd3aa17e9bd55489eb8d85fd5fa784a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb5542044d83eb4431cc3ce77f8034e1dd4984e7beb061bad0ee778d368b62d5"
  end

  depends_on "cmake" => :build
  depends_on "mariadb-connector-c"
  depends_on "openssl@3"
  depends_on "unixodbc"

  def install
    ENV.append_to_cflags "-I#{Formula["mariadb-connector-c"].opt_include}/mariadb"
    ENV.append "LDFLAGS", "-L#{Formula["mariadb-connector-c"].opt_lib}/mariadb"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["mariadb-connector-c"].opt_lib}/mariadb" if OS.linux?
    args = [
      "-DMARIADB_LINK_DYNAMIC=1",
      "-DWITH_SSL=OPENSSL",
      "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
      "-DWITH_IODBC=0",
      "-DICONV_INCLUDE_DIR=/usr/include",
    ]

    if OS.mac?
      # Workaround 3.1.11 issues finding system's built-in -liconv
      # See https://jira.mariadb.org/browse/ODBC-299
      args << "-DICONV_LIBRARIES=#{MacOS.sdk_path}/usr/lib/libiconv.tbd"
    end

    system "cmake", ".", *args, *std_cmake_args

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
