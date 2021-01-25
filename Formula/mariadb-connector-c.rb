class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.11/mariadb-connector-c-3.1.11-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.1.11-src.tar.gz"
  sha256 "3e6f6c399493fe90efdc21a3fe70c30434b7480e8195642a959f1dd7a0fa5b0f"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git"

  livecheck do
    url "https://downloads.mariadb.org/connector-c/+releases/"
    regex(%r{href=.*?connector-c/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 "336449db2c8c97536c63023289de0afe75324a7b85c1cd601e5248100cb8f34b" => :big_sur
    sha256 "32910577f524f9100dccee7efdf1fff27e2e2804c757ace2d84ac304f12c64d3" => :arm64_big_sur
    sha256 "2efbfa48262a5d9f5232d68ac6ae2d0e82fe55fed4cf2278cd2ec858a34d7e1a" => :catalina
    sha256 "31b05ada881147da4af8f2ac0b5402fcaa8e995876451e3af5d448f2df2cd609" => :mojave
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
