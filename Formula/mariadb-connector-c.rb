class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.0.8/mariadb-connector-c-3.0.8-src.tar.gz"
  sha256 "2ca368fd79e87e80497a5c9fd18922d8316af8584d87cecb35bd5897cb1efd05"

  bottle do
    sha256 "1e47ba9cf70adae3abebfd6ca55cdcf00de1785adb7439be01b39553702ee1ea" => :mojave
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
