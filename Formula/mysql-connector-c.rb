class MysqlConnectorC < Formula
  desc "MySQL database connector for C applications"
  homepage "https://dev.mysql.com/downloads/connector/c/"
  url "https://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.1.9-src.tar.gz"
  sha256 "4e808704443365ad5b649673d03eca8fbebc0a4da9f1f96616c6bd1b1901ab2b"

  bottle do
    sha256 "14f816bf3aeea9c0cf7b680112f3ca30b2e6f13b45da176a0f1cf888b3e7bc8b" => :sierra
    sha256 "ebfb58b01b144d79fc23f3a0e7abc8b59e7a59379519f7973aa66603a7033db6" => :el_capitan
    sha256 "b7cc223beca61228800d26878f7882b23afeb3a8a4297c1b2b84a9faa604a7e4" => :yosemite
    sha256 "c9a3c310c3eb3f9a0284b6b337bc531e0bb1e5351134fa7d8b26d331aaaebd7b" => :mavericks
    sha256 "5928f92ae51c122d69863ecfdda5f055bc0f6e8aea02c8ae484f3148747f5984" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  conflicts_with "mysql", "mariadb", "percona-server",
    :because => "both install MySQL client libraries"

  def install
    system "cmake", ".", "-DWITH_SSL=system", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match include.to_s, shell_output("#{bin}/mysql_config --cflags")
  end
end
