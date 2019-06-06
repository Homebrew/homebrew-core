class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.1/mariadb-connector-c-3.1.1-src.tar.gz"
  sha256 "b07027c37bc8ffce6b46407630f4ae0a453ca1fec9e790b619965765c27e0806"

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
