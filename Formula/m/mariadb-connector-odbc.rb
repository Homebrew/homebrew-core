class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://archive.mariadb.org/connector-odbc-3.1.20/mariadb-connector-odbc-3.1.20-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.1.20-src.tar.gz/"
  sha256 "41f7db83c907017be67f9941649e7ce1d3597c6d68f6241cb9b7709bbe2a490b"
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
    sha256 cellar: :any,                 arm64_sonoma:   "5b783c28dcb8d5d39b8457c620fbf0773fc6ac4e1e7d9c55de216a3693be6feb"
    sha256 cellar: :any,                 arm64_ventura:  "6d99d5481605562563960eb8b33a79a2699502b644349fe707eb4b1f112310ca"
    sha256 cellar: :any,                 arm64_monterey: "ae1c98f4eb41c5c398c36fde467053e7055c66127cc546f1602b2c872d3f14e0"
    sha256 cellar: :any,                 sonoma:         "70a23b157fbe6c05074a06a72d0ca68a468f5d73e7188b8ac242038edad3827f"
    sha256 cellar: :any,                 ventura:        "f89995e25ef01c57b054de0ce4c63ecf3e9fe611c8e29e8f5a9611c9e414adc4"
    sha256 cellar: :any,                 monterey:       "c1fa9c9bca57fcd93d73a7a6c3ba6d7d64471e863c35f3d15d0e9a31d9004e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40b5e4e395eea3ad115c1c4a7ce54ed791e74e99250567e57a402b67da129339"
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
