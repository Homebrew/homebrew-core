class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-odbc"
  url "https://archive.mariadb.org/connector-odbc-3.2.10/mariadb-connector-odbc-3.2.10-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-odbc-3.2.10-src.tar.gz/"
  sha256 "ee8b3472f9d7c19b50458893a958556a38f3d7900f91f97012a59bc2ab6f8869"
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
    sha256 cellar: :any, arm64_golden_gate: "f9abf981a59eaaca8e7e8ab3ac893b51ff0adf9bee36cbaf816affa28ad89e5f"
    sha256 cellar: :any, arm64_tahoe:       "47ed6682dfdf175ac189bba8855fbedc4474f6fbc98c3fe0de333d0a7fc96a24"
    sha256 cellar: :any, arm64_sequoia:     "5adc3518e66d8c5060fe847b40dcaaa2ad4f591c9fba5a2994fce457ed0b5d65"
    sha256 cellar: :any, arm64_linux:       "8dab92b09683f1bf99f65e6ad8dc399d8fc22083f673e1895b3b7a0185a5c5ac"
    sha256 cellar: :any, x86_64_linux:      "60339d93d34e7d95cc53382193a76a485f26ce76b8e02d966e89c9d677edca69"
  end

  depends_on "cmake" => :build
  depends_on "mariadb-connector-c"
  depends_on "unixodbc"

  deny_network_access!

  def install
    ENV.append_to_cflags "-I#{formula_opt_include("mariadb-connector-c")}/mariadb"
    args = %w[
      -DMARIADB_LINK_DYNAMIC=ON
      -DWITH_IODBC=OFF
      -DWITH_SSL=OPENSSL
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # By default, the installer pkg is built - we don't want that.
    # maodbc limits the build to just the connector itself.
    # install/fast prevents an "all" build being invoked that a regular "install" would do.
    system "cmake", "--build", "build", "--target", "maodbc"
    system "cmake", "--build", "build", "--target", "install/fast"
  end

  test do
    output = shell_output("#{formula_opt_bin("unixodbc")}/dltest #{lib}/mariadb/#{shared_library("libmaodbc")}")
    assert_equal "SUCCESS: Loaded #{lib}/mariadb/#{shared_library("libmaodbc")}", output.chomp
  end
end
