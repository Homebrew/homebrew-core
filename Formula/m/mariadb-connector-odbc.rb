class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://archive.mariadb.org/connector-odbc-3.2.2/mariadb-connector-odbc-3.2.2-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.2.2-src.tar.gz/"
  sha256 "1dbff92d2f895e6d0c8c765a31c144b0cbdacd9947a40eb78992515f8f0507d2"
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
    sha256 cellar: :any,                 arm64_sonoma:   "16e696d064c3918896d1f3644cd334547d0136d13f7ccabfdc3041e54e0fe36f"
    sha256 cellar: :any,                 arm64_ventura:  "078365f147b8b2da131c91d29d6d185607cdf2b42ece88103dfeebedd21da96b"
    sha256 cellar: :any,                 arm64_monterey: "f2adde7b3254d5a2742ab4460b4a603c550c1d99a82a4fd287b1787628a44dab"
    sha256 cellar: :any,                 sonoma:         "09d1f87e03817fe209893a5751b7c7e6e2e452879cb972027a3b9b6dd11f9111"
    sha256 cellar: :any,                 ventura:        "54e9b21d2917d7cb3e9a9c07141e3a548ea632e7688565f63208636e770c3295"
    sha256 cellar: :any,                 monterey:       "12199bfc75ec236ac747e19c8b834b258309e558775343278283a5cbe75fc532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "416141985c8eca398c134d5d6f187e1f54162f061134b27182bed9aa12f7ecb6"
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
