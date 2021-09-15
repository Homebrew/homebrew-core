class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.2.3/mariadb-connector-c-3.2.3-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.2.3-src.tar.gz"
  sha256 "b6aa38656438e092242a95d01d3a80a5ce95c7fc02ec81009f4f0f46262331f4"
  license "LGPL-2.1-or-later"
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git"

  livecheck do
    url "https://downloads.mariadb.org/connector-c/+releases/"
    regex(%r{href=.*?connector-c/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_big_sur: "ed5e5cfae975c148bf18db33cab2b2763399b1909c921e213c5ad3ad5f23abac"
    sha256 big_sur:       "78f04f9c5b00aa98a85e8b6ba25532fa69e8a343ab9fecdc5288cba267e13a0d"
    sha256 catalina:      "8b80541bacc80391c6966a017eadb32ae621293c9c38a7e2bebc66cdb306e2fd"
    sha256 mojave:        "906e69c8690c78a5571932f927d40eee87385a861cd0dc2983c92bdd62f6c617"
    sha256 x86_64_linux:  "c5c5385b1661b29894e8baa513d2a507cf87bff2752ac9ff3b27af6f662b317c"
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
