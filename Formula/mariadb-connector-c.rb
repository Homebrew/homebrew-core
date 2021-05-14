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
    sha256 arm64_big_sur: "578958505453c5d918388702108e6bbb9d4f86367ebf12cb08d1c1de03486aae"
    sha256 big_sur:       "477ccf03090ae5e1ab301c93c4f07ceae1769e3c186858e3194cf311f803f03d"
    sha256 catalina:      "1edcf6c7a0ffe45dd91c6377c423bdb0c96081a84b83eab17027fcfb085901f7"
    sha256 mojave:        "3bccbdb436920b3254539bf7cab469bf3200999aca0e043891e56bf3f45889c7"
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
