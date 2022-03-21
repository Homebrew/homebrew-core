class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://downloads.mariadb.com/Connectors/c/connector-c-3.2.6/mariadb-connector-c-3.2.6-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.2.6-src.tar.gz/"
  sha256 "9c22fff9d18db7ebdcb63979882fb6b68d2036cf2eb62f043eac922cd36bdb91"
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
    sha256 arm64_monterey: "a26f011092cfc5962d0fe3331ace48a40e4d7fc9001bd7fca89efbfe68308a08"
    sha256 arm64_big_sur:  "0631d039b19fa059891ebf8a1c4c60af89748db33932b10c4538d4a54ddefc0e"
    sha256 monterey:       "e7de3468abc7b07e6c94034ba3ada6a968623dde712b6a21188ad222561e63ce"
    sha256 big_sur:        "31f236b45772756f8999afb3f6199316f2932b95185dcec65ccce4a53e093822"
    sha256 catalina:       "88bb6df52bfa57ead262cc0a5e9ec05efb6cd4c8ba31525d0fd52b7876b4fa37"
    sha256 x86_64_linux:   "b76dab98adafa4669aee3c1e99615823d0288d2f8f140ac4fb5cf8180d1fa86f"
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
