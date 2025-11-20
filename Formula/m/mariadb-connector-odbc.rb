class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://archive.mariadb.org/connector-odbc-3.2.7/mariadb-connector-odbc-3.2.7-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.2.7-src.tar.gz/"
  sha256 "11ce94737004695eedaf66a72eeafcb43fb68ccac7dbb5baa16054dac539fdb3"
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
    sha256 cellar: :any,                 arm64_tahoe:   "f1b29c1a0dc8071a331fa1369a039b0d96886ff79bb36136f0f1a9eac9f63c8d"
    sha256 cellar: :any,                 arm64_sequoia: "eece3cd9be87900f014ce2de36febebb8380b85e8f537945166e9c947a4b0adc"
    sha256 cellar: :any,                 arm64_sonoma:  "57e869ba04df6eacce2bdc1215f313b2d63c77f90335dbc05b1b874172b23834"
    sha256 cellar: :any,                 sonoma:        "7f5fce54d902b89f9fd938141cd2660c46996dc8a3c47fa865fc43c1962dcf52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fc9d0e3edfd19c4a344d640fc7f14397928353f5a7d46174d673c82be028653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b1be91aad52a4b13d528745770baf59ba410b3207b87084c55caa06c702457"
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
