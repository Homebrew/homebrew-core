class MysqlConnectorC < Formula
  desc "MySQL database connector for C applications"
  homepage "https://dev.mysql.com/downloads/connector/c/"
  url "https://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.1.11-src.tar.gz"
  sha256 "c8664851487200162b38b6f3c8db69850bd4f0e4c5ff5a6d161dbfb5cb76b6c4"

  bottle do
    sha256 "37bae1f207e5f2dcaf4bfbf5dd0a171d512cc55f801500f2d3a8c2af6961e482" => :catalina
    sha256 "e659605251a2ac9a57da2c781e89dc33a8836aa656c804c1e617fa7ed3d59919" => :mojave
    sha256 "3b84a7deb748b5e7c7674f449e7a2ae451bb1b8838d8841ddf7001ef32673364" => :high_sierra
    sha256 "bb5c0c5854d6af0299c18d14a48dcb6dc5fdca98b2bde9b4c654c5584c3670b1" => :sierra
    sha256 "e2035138e14b87fb0ff971ab9bc34631140ac0478e250866d9ce236de952c66e" => :el_capitan
    sha256 "d6aaf4eca97640dc5f5785a2bf8cc45cf7d829d50798ee0f6551b473c621b792" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl" # no OpenSSL 1.1 support

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
