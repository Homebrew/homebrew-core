class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.2/mariadb-connector-c-3.1.2-src.tar.gz"
  sha256 "156aa2de91fd9607fa6c638d23888082b6dd07628652697992bba6d15045ff5d"
  revision 1

  bottle do
    sha256 "b64eb44ed34e785ccb71b71452d0a7073409ffb589c1b33fe49de6bc9a031820" => :mojave
    sha256 "50663d29b7cf483e8bbf554f329110c79939fdba54850c9e046d6460d992429f" => :high_sierra
    sha256 "98f0045250155bbf5cc2dd34771f76bb54544496a6b63ce2f61032f9cfd22a43" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  conflicts_with "mysql", "mariadb", "percona-server",
                 :because => "both install plugins"

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
