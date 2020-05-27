class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.8/mariadb-connector-c-3.1.8-src.tar.gz"
  sha256 "431434d3926f4bcce2e5c97240609983f60d7ff50df5a72083934759bb863f7b"

  bottle do
    sha256 "9b46c115a5e52eda9c098ddb5f426119af1b2fe706c936a23af9dcd8396e5a2d" => :catalina
    sha256 "b1677f7aab7d36908ec07abe4427fb1d04929a7d59a5b08de103a5ae573dffea" => :mojave
    sha256 "c681d5b8bf178d5e1e4bd6ea08ed819fe1128845dc290eda2776e7c06731731f" => :high_sierra
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
