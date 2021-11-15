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
    sha256 arm64_monterey: "ceb4ed8ef1577513f4a2894c84fc1493f934d5e0890e1604e0e87968f2eea440"
    sha256 arm64_big_sur:  "6e4c10a0186b34fcad4bc34f25c15ad2d17a6be10ed826a42b41bb2417f6abc9"
    sha256 monterey:       "a270d6a54be27de1b1046442f6f234838a4970d06cc36ff0d6eb329bbbfd3347"
    sha256 big_sur:        "5689a9fc8d1f00df4f98eaae4c0d65de90089bad8e38d3ca21f00e89f8c507fd"
    sha256 catalina:       "2776adc988cc46b619fc6b21ad17fca88612f32b3b4056975e0534d52532dcb4"
    sha256 x86_64_linux:   "8003aa9abf2344e26b2534b243e021ee1dcc7fcc742450c4db5b2eded6da27c3"
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
