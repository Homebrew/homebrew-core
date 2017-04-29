class MysqlConnectorC < Formula
  desc "MySQL database connector for C applications"
  homepage "https://dev.mysql.com/downloads/connector/c/"
  url "https://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.1.10-src.tar.gz"
  sha256 "73d2c3d633dcec63b9e985e524cc386ce52ddedcd06bdc40e094aaae35b14a69"

  bottle do
    sha256 "a5719207674a94a3e2303b246f48e71f3726a95388e733e19abbb732eea95a95" => :sierra
    sha256 "06082e549fec918fea7d09ea80f6a9f1bc1ed645b0938879c57a4cb16620efa4" => :el_capitan
    sha256 "539f992aae3609351505d4e1214f706905234c95774fa678090ec15b466144f0" => :yosemite
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
