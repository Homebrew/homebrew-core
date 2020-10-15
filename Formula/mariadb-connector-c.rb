class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.10/mariadb-connector-c-3.1.10-src.tar.gz"
  sha256 "af3e5613cb9e811f70db85a8a704c7140dc3e35f7c39912d0509511638f9658f"
  license "LGPL-2.1-or-later"
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git"

  livecheck do
    url "https://downloads.mariadb.org/connector-c/+releases/"
    regex(%r{href=.*?connector-c/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 "1450e02b0bb188edb8b104bc3d238a267f98d285791938b0e9bfcbdb5b8475e5" => :catalina
    sha256 "344dc040d56b52b9d6eb5dbadf25a1795d0bffd98b6150fbb23b58e7bdcabe8c" => :mojave
    sha256 "6f91bed0bab61a64d263afbd6a2fe0eb6eb111f8417e5d32a0b456ad29d3e7a1" => :high_sierra
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
