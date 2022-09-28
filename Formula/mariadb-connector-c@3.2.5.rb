class MariadbConnectorCAT325 < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://downloads.mariadb.com/Connectors/c/connector-c-3.2.5/mariadb-connector-c-3.2.5-src.tar.gz"
  sha256 "296b992aec9fdb63fb971163e00ff6d9299b09459fba2802a839e3185b8d0e70"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/href=.*?apache-ant[._-]v?(1\.9(?:\.\d+)*)(?:-bin)?\.t/i)
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
