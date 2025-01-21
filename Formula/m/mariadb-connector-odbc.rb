class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://archive.mariadb.org/connector-odbc-3.2.4/mariadb-connector-odbc-3.2.4-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.2.4-src.tar.gz/"
  sha256 "964812d9b0df0a03482fbddb79ccab6a1879f14e9258476c57b5796cdb7f004b"
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
    sha256 cellar: :any,                 arm64_sequoia: "68d779eda8256080dc4bc7413144d7e76ad1e56ade42aaf3ee69bc2b2e721269"
    sha256 cellar: :any,                 arm64_sonoma:  "2b6ca27ca543bf9c3b640e3b79d4c52525e27c0a56faecb0405311c1a6dc5405"
    sha256 cellar: :any,                 arm64_ventura: "b15a8af2b708d497840b89b6df4cba3a62d686a854ce68629eab14a12ad808e5"
    sha256 cellar: :any,                 sonoma:        "d14a130ef6d1228073a442770200607a1246ea8554680fe27dc93bc7c7087940"
    sha256 cellar: :any,                 ventura:       "6116655b653ceb3979eaea39840d3f2fbb8e67f2e5162e1fda189bc698a81ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d17cbca36bc9f82b0e31201ffa3c1cfb304f6058c94fb59de7085fec07809245"
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
