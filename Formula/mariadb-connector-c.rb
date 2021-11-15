class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://downloads.mariadb.com/Connectors/c/connector-c-3.2.5/mariadb-connector-c-3.2.5-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.2.5-src.tar.gz/"
  sha256 "296b992aec9fdb63fb971163e00ff6d9299b09459fba2802a839e3185b8d0e70"
  license "LGPL-2.1-or-later"
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git", branch: "3.2"

  # https://mariadb.org/download/ sometimes lists an older version as newest,
  # so we check the JSON data used to populate the mariadb.com downloads page
  # (which lists GA releases).
  livecheck do
    url "https://mariadb.com/downloads_data.json"
    regex(/href=.*?mariadb-connector-c[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "37ee7dc927debb9cdc8100f3225f1426fa4351425e069cdd8921b52ca196b73b"
    sha256 big_sur:       "b16d4452c5ed1025c3c57b75455eef88a69e85ed85bd63f9d03e2a9698321195"
    sha256 catalina:      "c3f7de51c744f7bb7117747d1bcad45878f02d76b9f8ee5747a4e5606e682708"
    sha256 x86_64_linux:  "31c5124ff56e2cf35ad23bb6f6e0b89a9b1f339a9e8a8b2012aa21923b79bb8b"
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
