class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.7/mariadb-connector-c-3.1.7-src.tar.gz"
  sha256 "64f7bc8f5df3200ba6e3080f68ee4942382a33e8371baea8ca4b9242746df59a"

  bottle do
    sha256 "4398d6a99238b3e29c4dc5ad2426febd0d2884b81df7042cc888fb233da4fbc6" => :catalina
    sha256 "ea55803a15dc9806e3f521bfde2eeaa304a7350224463cbeb3394215f58eb6f3" => :mojave
    sha256 "0d853c1cbac3f3a3b3ed00825f3c4cb3bf12a27130ac90ad3d802b1282f81b27" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  conflicts_with "mariadb",
                 :because => "both install mariadb_config"

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
