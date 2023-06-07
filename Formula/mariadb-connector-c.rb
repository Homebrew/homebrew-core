class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://downloads.mariadb.com/Connectors/c/connector-c-3.3.5/mariadb-connector-c-3.3.5-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.3.5-src.tar.gz/"
  sha256 "ca72eb26f6db2befa77e48ff966f71bcd3cb44b33bd8bbb810b65e6d011c1e5c"
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
    sha256 arm64_ventura:  "238bbf5adca4e691f766dee350f8af0cc705980f0f5be1da5b985f6fe378c45f"
    sha256 arm64_monterey: "4fc0eb95fef5ee0f11fae8278659026d16bdac5796f5d114bf721ff4a4cbd255"
    sha256 arm64_big_sur:  "7ae35f16069e8b28c152145f9e02fbb29bba54ddeb03bf3ca2ed919249202ce6"
    sha256 ventura:        "603965733c9df0c47ca7427933407c1f4b053854fed4bffc80c952e38a6bf051"
    sha256 monterey:       "4ff8d7b387ed475af53e2536e572435a44883557ab497601e158cae2c946725b"
    sha256 big_sur:        "feefbbdb0fe5d1f33621f7e5269b1faed14da08b2235d83439dee78c820ea29e"
    sha256 x86_64_linux:   "3f13a332a0135ac91b8f44616ef01d9da363d6296cc08ab67023f36c90ae62a2"
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
