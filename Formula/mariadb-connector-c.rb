class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.0.10/mariadb-connector-c-3.0.10-src.tar.gz"
  sha256 "bd9aa1f137ead3dc68ed3165adc53541712076d08949800b6ccebd33da6d0ae8"

  bottle do
    sha256 "6484a2490a2b50896c990cea94d3f1d50cce7c55005efda99e27e1121dffdeca" => :mojave
    sha256 "8dd3b15d9add1a76e5d61280477a6838c5c4d56742bb6468bb71d240a7fabafd" => :high_sierra
    sha256 "bbf35b53bd41b21c3b66554474a7a518be3aaf37693df95499f6db92a01a1d52" => :sierra
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
