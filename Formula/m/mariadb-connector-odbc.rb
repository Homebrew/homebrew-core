class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://archive.mariadb.org/connector-odbc-3.2.5/mariadb-connector-odbc-3.2.5-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.2.5-src.tar.gz/"
  sha256 "3b728f8b5f446581759cc3fb0d7a66ee83d33f96c0a77389b37886bdd9c27e31"
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
    sha256 cellar: :any,                 arm64_sequoia: "1cab56f15dd35ed8c393e3a445ddafc6df35dc91a5ba683e2bd12d58fba48018"
    sha256 cellar: :any,                 arm64_sonoma:  "9147c94a43745b22d550d87f43e3281e8d8e6846b3420b9fe809f08337c9625f"
    sha256 cellar: :any,                 arm64_ventura: "afef9afb946a690d32cdccee6c780f36e24b539c7be0c7a38033f84440f58fa8"
    sha256 cellar: :any,                 sonoma:        "30c5cbc64f95f1329de018a9b631260e9dc8b3947d6a6e6c3cc0ad7bcc040b9a"
    sha256 cellar: :any,                 ventura:       "2b851dac6b57ca7d360abf3acd14562b46c9b8659fe8b361a0fef71d206d79b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b1a31a76c901d52ed43fc7a1be602a63bdd904fd0740d90de24a5d5d525d55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7ceb001faf0bb863b136fac7da261cd92b28b135d1d880252a58859be587cc"
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
