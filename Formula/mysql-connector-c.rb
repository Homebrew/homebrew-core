class MysqlConnectorC < Formula
  desc "MySQL database connector for C applications"
  homepage "https://dev.mysql.com/downloads/connector/c/"
  url "https://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.1.10-src.tar.gz"
  sha256 "73d2c3d633dcec63b9e985e524cc386ce52ddedcd06bdc40e094aaae35b14a69"

  bottle do
    sha256 "6f0b845224739ff3e1405bb94e96a24c99ce1007eff212168c86b3f6ba37c4ac" => :sierra
    sha256 "252b03549c645c40155c281e02ffb130298bca5efdf40d2179051dd854e1b0ed" => :el_capitan
    sha256 "2e5182e2fd30babb7aba13049c0f36e05b0f3ebf0e9bb2dc64370f28047ba955" => :yosemite
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
