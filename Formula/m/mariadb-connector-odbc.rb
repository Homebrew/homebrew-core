class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://archive.mariadb.org/connector-odbc-3.2.8/mariadb-connector-odbc-3.2.8-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.2.8-src.tar.gz/"
  sha256 "9968979aae46a1750452eb934558af81c6eda957eaee00f7ec72b24ee8ead547"
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
    sha256 cellar: :any,                 arm64_tahoe:   "6503f5e12ba9a93fe77b5e3c3531da76a86250f87fb4213334e16cdfca4c9198"
    sha256 cellar: :any,                 arm64_sequoia: "e60dd366ab6cad4d935fe9ed114ad12ff3747a53404bc77fab2b45d6633430d4"
    sha256 cellar: :any,                 arm64_sonoma:  "80f260c40418203e6e9c5cdeb8e2b317f71d47c2dab4ab7206ae77f4c0e63f7f"
    sha256 cellar: :any,                 sonoma:        "e34194f7649b50234942d6b531a73720d2a1d4b61895dc5856f9bf6f70c27313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c4da9595f5dd992339dd64d9edc7c017dbb59e880cf315385fc6d4471ee2468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a136c005bebcf4467b18b05958444557bb152c016a3d74fd4e2d60b00cc331f"
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
