class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://downloads.mariadb.com/Connectors/c/connector-c-3.3.4/mariadb-connector-c-3.3.4-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.3.4-src.tar.gz/"
  sha256 "486e5fdf976a8e7fadf583ae912128655e013ac575fa79b2d1af0fb8827a78ed"
  license "LGPL-2.1-or-later"
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git", branch: "3.3"

  # https://mariadb.org/download/ sometimes lists an older version as newest,
  # so we check the JSON data used to populate the mariadb.com downloads page
  # (which lists GA releases).
  livecheck do
    url "https://mariadb.com/downloads_data.json"
    regex(/href=.*?mariadb-connector-c[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e3e26fcd4c4ca515a1266a046e72ae3968936795deb3ef1da17e5f35eae9d634"
    sha256 arm64_monterey: "2fd04d6f77123312ee272e5695324a1a7bd79730cbeab7471a9089c7ed60605e"
    sha256 arm64_big_sur:  "fb69795d4731538d86fdcc5892051b39ad150a68eb26dd112f6bef18df2ff8a7"
    sha256 ventura:        "a7281ed033f530a89ba1922479c6441780de87d49ba83dcaab5635c09962b63c"
    sha256 monterey:       "40429aff8742a48d41c83408cfacbbacf199193ee85000b7ca5e835d1abbafac"
    sha256 big_sur:        "b75ad7f21b40bdb2299101ed2150a7fd5531093a233b84d6d9b8a533300649db"
    sha256 x86_64_linux:   "b467dc55a2be180b0e73b8babda386bd3eccd7b565e757717c6c75d6cf5922fd"
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
    args << "-DINSTALL_MANDIR=#{share}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
