class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.2/mariadb-connector-c-3.1.2-src.tar.gz"
  sha256 "156aa2de91fd9607fa6c638d23888082b6dd07628652697992bba6d15045ff5d"
  revision 1

  bottle do
    sha256 "a5e5e383e113c0bf8d3a88ee9ca6d0c4c7a3b28daf97306a1dd08c7ac0636f29" => :mojave
    sha256 "ad83bcb819219a05a9f6e3143e925673aad853dc9b0d8053eb78221e368a6b68" => :high_sierra
    sha256 "b5a6c04504a6308f05fe279aa1e7cbafd296bcd47130feb59727e9e22714c434" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  conflicts_with "mysql", "mariadb", "percona-server",
                 :because => "both install plugins"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl@1.1"].opt_include}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
