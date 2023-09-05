class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://archive.mariadb.org/connector-c-3.3.5/mariadb-connector-c-3.3.5-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.3.5-src.tar.gz/"
  sha256 "ca72eb26f6db2befa77e48ff966f71bcd3cb44b33bd8bbb810b65e6d011c1e5c"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git", branch: "3.3"

  # The REST API may omit the newest major/minor versions unless the
  # `olderReleases` parameter is set to `true`.
  livecheck do
    url "https://downloads.mariadb.org/rest-api/connector-c/all-releases/?olderReleases=true"
    strategy :json do |json|
      json["releases"]&.map do |_, group|
        group["children"]&.map do |release|
          next if release["status"] != "stable"

          release["release_number"]
        end
      end&.flatten
    end
  end

  bottle do
    sha256 arm64_ventura:  "7932a4f074df7dd50077a4b4aa1d819cc19fdf64c1f7a383ab99268c29318b10"
    sha256 arm64_monterey: "f4409ff5557b12c7e1eade9fbd5d89379a4303a7d214bd2ea02ac1e92a881b2b"
    sha256 arm64_big_sur:  "bb5f15c4577c75378afd14255e51db5f58e231650c6866c48f7d2cfd5d925bf7"
    sha256 ventura:        "dc5a037a2d19e855997614eb1fa9201ba2a91c96a6225f0da3ffbd12ca7a8703"
    sha256 monterey:       "b3534cdba8a3c6703fe7c8aa4dc2968889501708e5b87efa9f0a7c3a93620d5c"
    sha256 big_sur:        "d7acccd5f728af488f6a788bc736f7952e8e564a88e0943b6856365df1e5034b"
    sha256 x86_64_linux:   "2131d46f59bf30bf4f75ca1b4b11c2ba88eff7cd4c9e5e6a3beb2e9854af1c3e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "mariadb", because: "both install `mariadb_config`"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DWITH_EXTERNAL_ZLIB=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl@3"].opt_include}"
    args << "-DINSTALL_MANDIR=#{share}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
