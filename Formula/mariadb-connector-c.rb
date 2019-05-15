class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.0.10/mariadb-connector-c-3.0.10-src.tar.gz"
  sha256 "bd9aa1f137ead3dc68ed3165adc53541712076d08949800b6ccebd33da6d0ae8"

  bottle do
    sha256 "6fc381aa27ac6aed4eca014b64da58ce6dd6abe172ee03c1471bd9ad2da6ee92" => :mojave
    sha256 "14003286a278b4c804806363755a6fafe0641100e9f9b5d90266d4267754a524" => :high_sierra
    sha256 "f2066ea91e1a39617ddde93ffc1421e5d7f4f8097146803455f9e69de7abcf96" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  conflicts_with "mysql", "mariadb", "percona-server",
                 :because => "both install plugins"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl"].opt_include}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
