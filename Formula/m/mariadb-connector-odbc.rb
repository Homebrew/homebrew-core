class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://archive.mariadb.org/connector-odbc-3.2.9/mariadb-connector-odbc-3.2.9-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.2.9-src.tar.gz/"
  sha256 "5062f491f7189ba32352a9834777886dfbc64a107bb0e2e50921dd6ae2bd18ad"
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
    sha256 cellar: :any, arm64_tahoe:   "09f87fd4c0502b249fd72332f2fbe85a2b9184ae189ccff1f9a1b1ff78f6b845"
    sha256 cellar: :any, arm64_sequoia: "ffd0a58eba76d4434319d170602256cb2c18b5d1182306a712320f45a711f8bc"
    sha256 cellar: :any, arm64_sonoma:  "bf33a22cb5e79a66f74ca08f2387801e20c343fc16789c2a46a502ebbfd56179"
    sha256 cellar: :any, sonoma:        "616d424ae62016620e3d9116f7c208eaf250227ada9cc247ead3e8214a799e2d"
    sha256 cellar: :any, arm64_linux:   "0335130359241a3724615c13e6790c07298557c1b972b4ada44cd3e788b923d6"
    sha256 cellar: :any, x86_64_linux:  "678b773b91fe9df520e42e1b27cc958234a927ab778bc2ba56a30079946dc556"
  end

  depends_on "cmake" => :build
  depends_on "mariadb-connector-c"
  depends_on "openssl@3"
  depends_on "unixodbc"

  def install
    ENV.append_to_cflags "-I#{formula_opt_include("mariadb-connector-c")}/mariadb"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("mariadb-connector-c")}/mariadb"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{formula_opt_lib("mariadb-connector-c")}/mariadb" if OS.linux?
    args = [
      "-DMARIADB_LINK_DYNAMIC=1",
      "-DWITH_SSL=OPENSSL",
      "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}",
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
    output = shell_output("#{formula_opt_bin("unixodbc")}/dltest #{lib}/mariadb/#{shared_library("libmaodbc")}")
    assert_equal "SUCCESS: Loaded #{lib}/mariadb/#{shared_library("libmaodbc")}", output.chomp
  end
end
