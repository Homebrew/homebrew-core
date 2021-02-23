class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.12/mariadb-connector-c-3.1.12-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.1.12-src.tar.gz"
  sha256 "2f5ae14708b4813e4ff6857d152c22e6fc0e551c9fa743c1ef81a68e3254fe63"
  license "LGPL-2.1-or-later"
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git"

  livecheck do
    url "https://downloads.mariadb.org/connector-c/+releases/"
    regex(%r{href=.*?connector-c/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_big_sur: "32910577f524f9100dccee7efdf1fff27e2e2804c757ace2d84ac304f12c64d3"
    sha256 big_sur:       "336449db2c8c97536c63023289de0afe75324a7b85c1cd601e5248100cb8f34b"
    sha256 catalina:      "2efbfa48262a5d9f5232d68ac6ae2d0e82fe55fed4cf2278cd2ec858a34d7e1a"
    sha256 mojave:        "31b05ada881147da4af8f2ac0b5402fcaa8e995876451e3af5d448f2df2cd609"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "mariadb", because: "both install `mariadb_config`"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DWITH_EXTERNAL_ZLIB=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl@1.1"].opt_include}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
