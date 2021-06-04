class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.13/mariadb-connector-c-3.1.13-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.1.13-src.tar.gz"
  sha256 "0271a5edfd64b13bca5937267474e4747d832ec62e169fc2589d2ead63746875"
  license "LGPL-2.1-or-later"
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git"

  livecheck do
    url "https://downloads.mariadb.org/connector-c/+releases/"
    regex(%r{href=.*?connector-c/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_big_sur: "e27d0730e73863cb95fa2b3560349f7eb24020c98d43f2b503e5388f5892be25"
    sha256 big_sur:       "099ba88bc3bf0daa6f374888570e6b8bbc272ec631b2e06acd55f48489bd2361"
    sha256 catalina:      "84e0f32d9d23c8ada92f4758b27ea2ce09c6022f792a9cca9549adec68f8c16d"
    sha256 mojave:        "500d2d6eeda98ff48fdd69600637406e292e2d5b0da5b8466050ebc41956b919"
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
