class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.0.3/mariadb-connector-c-3.0.3-src.tar.gz"
  sha256 "210f0ee3414b235d3db8e98e9e5a0a98381ecf771e67ca4a688036368984eeea"

  bottle do
    sha256 "43b657d33bd13473ccd6692e6d33ec6abb01a56891b610e75e0e4db5f6501feb" => :high_sierra
    sha256 "a89b9f6276d8c29b0775883686447cb593d9b2e50c7ac7af4e57870db0652998" => :sierra
    sha256 "4c63069a76d6fe43ebd97654884b06dab7b67782b3776cb49c8b11624ca4ba92" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  conflicts_with "mysql", "mariadb", "percona-server",
                 :because => "both install plugins"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl"].opt_include}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
