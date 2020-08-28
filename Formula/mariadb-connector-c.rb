class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.9/mariadb-connector-c-3.1.9-src.tar.gz"
  sha256 "108d99bf2add434dcb3bd9526ba1d89a2b9a943b62dcd9d0a41fcbef8ffbf2c7"
  license "LGPL-2.1"
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git"

  livecheck do
    url "https://downloads.mariadb.org/connector-c/+releases/"
    regex(%r{href=.*?connector-c/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 "830dec16151d5d8f7d2c4e3925f9fba5b911d7fe3b9ec07eec23079e0b85293b" => :catalina
    sha256 "3ce47f04785021838696176ba2da5b79cf5ed5bd7870531701efc47d2e20cbc4" => :mojave
    sha256 "330e6d5f322494e9deaefd46ec3a8604509b5880b08bc125f6e1a164e01933de" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  conflicts_with "mariadb", because: "both install `mariadb_config`"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl@1.1"].opt_include}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
