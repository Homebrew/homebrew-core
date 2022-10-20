class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://downloads.mariadb.com/Connectors/c/connector-c-3.3.2/mariadb-connector-c-3.3.2-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.3.2-src.tar.gz/"
  sha256 "7e0722e07d30bb906fac9fe10fb582cde1e148e05a83d9ca7b6fcc884b68fbce"
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
    sha256 arm64_monterey: "28cd53c9451194da94ed22382060c95b01f32226773677f526c5249407c8da7d"
    sha256 arm64_big_sur:  "867bfea66548adb9893b570a346cf773b4e78d7e41fff26c91038728e3fca69d"
    sha256 monterey:       "2ad5a88aaf06bfd3497ff3456688d1f08a99e0f88af2bab2c752a202eab2ff33"
    sha256 big_sur:        "7a902856f3b57fcfce029610344d9a97d07349af4dc19edb4ffa2f0ca3559cc4"
    sha256 catalina:       "0a3e6735f17398d2f41a8fefce33c690042c953c7415d15e46b41f38f8283194"
    sha256 x86_64_linux:   "f797d3f35c8b782d661782d7a3cabbd782c0ee54e198d2a434d921c3faa0b7e9"
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
