class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.7/mariadb-connector-c-3.1.7-src.tar.gz"
  sha256 "64f7bc8f5df3200ba6e3080f68ee4942382a33e8371baea8ca4b9242746df59a"

  bottle do
    sha256 "b45cc1f8d53b6d24fdbf588d7120de36f9bcd315860dab27768c9a752f6ad333" => :catalina
    sha256 "4ae4e9fd1fd1d054393d641576ce4bf122937d79aa52cb0e185fe94d02345752" => :mojave
    sha256 "93981e72f4b5054c5bdb74706bcf7795da5011c0267773c7789b381a1ada0132" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

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
