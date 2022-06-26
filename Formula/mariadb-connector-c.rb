class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://downloads.mariadb.com/Connectors/c/connector-c-3.3.1/mariadb-connector-c-3.3.1-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.3.1-src.tar.gz/"
  sha256 "29993f4ae4c975662724978792d1a503b9ee760fbb194d321a754253cbe60aad"
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
    sha256 arm64_monterey: "e87f0b4195423db4516d735fd9d49b1929e0443c6b75165d26010039246e1202"
    sha256 arm64_big_sur:  "0266be9c9ee351093dbef7a1a5667400b9fe1c7d6762a7dee3702cd0dbfa7225"
    sha256 monterey:       "248ca9ef8db5a8e1bfc5e021ff617a362d87c99c204ef5477709653c90b303bd"
    sha256 big_sur:        "1293355de11b8fc6816b1b19232ff7b999cf78ad858ab2edc47386774361db3c"
    sha256 catalina:       "c0643d1e335b5fcd6b14f211217ae726cbde32b335694df1fcb576896b5ced5b"
    sha256 x86_64_linux:   "c0a4f0ebdfce29cbdab3904731ac321e45d709223fee45e4eba57fb8ff1418d8"
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
