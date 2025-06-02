class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://archive.mariadb.org/connector-odbc-3.2.6/mariadb-connector-odbc-3.2.6-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.2.6-src.tar.gz/"
  sha256 "ec125605ac6773df260fa73986e921d7c3f1ee18bf0a9a2eb201ee6db1b2e079"
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
    sha256 cellar: :any,                 arm64_sequoia: "820b7800ecdc5747a19f6fb1d6c1c91921a4178f7f3e4bfed859438f2cacef9d"
    sha256 cellar: :any,                 arm64_sonoma:  "b568d69cbcea0eed78eca6a8a6320b71643b1c1352febd2385787ee3209e1121"
    sha256 cellar: :any,                 arm64_ventura: "ba4df0a0754548620a2e53b6dac5724287c2b384b823f63e416163a5a014b0f4"
    sha256 cellar: :any,                 sonoma:        "de0da2df292f68d6f6c78dd72fa6048ae2930f55e83b3b5b5113d00d4929e926"
    sha256 cellar: :any,                 ventura:       "c3bd01e6d6d22cb1ff8d2e077d7c86ba60a5896406eec65be2b3fdc2b53a0b1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c793bc94d7decff7728d335e6ec732c9d2505cb796c989a6ef44e546731346fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43a577e82496111a7bd4b289884810a4c1f730356f0d4e13c0e8e260afc69a19"
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
