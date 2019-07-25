class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.2/mariadb-connector-c-3.1.2-src.tar.gz"
  sha256 "156aa2de91fd9607fa6c638d23888082b6dd07628652697992bba6d15045ff5d"

  bottle do
    sha256 "e147e1a76a7a9c1da7831c981adf0d009d05be5f5039b493196a6610a00a7258" => :mojave
    sha256 "f13a08e7b779ba4d692548e7a65a13a6c1044952345538d8cd3d64169a6e82f6" => :high_sierra
    sha256 "d7a759c8158064177832bb4be7d44ad622ad8abe505a14b05c3e9d8c7ef0f3dd" => :sierra
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
