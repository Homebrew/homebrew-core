class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://downloads.mariadb.com/Connectors/c/connector-c-3.3.3/mariadb-connector-c-3.3.3-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.3.3-src.tar.gz/"
  sha256 "d77630e2376fe08185b5354621c877b0a203a6b186a0694574d37b764aeb2874"
  license "LGPL-2.1-or-later"
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git", branch: "3.3"

  # https://mariadb.org/download/ sometimes lists an older version as newest,
  # so we check the JSON data used to populate the mariadb.com downloads page
  # (which lists GA releases).
  livecheck do
    url "https://mariadb.com/downloads_data.json"
    regex(/href=.*?mariadb-connector-c[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b97bd4602f08f0183f63ac2b38d066bfd9e34245dda2aebcb24b78e3958bf9ec"
    sha256 arm64_monterey: "086138120674893e58c030bd30bb8dc6fbb20ba8e49791c4113c1ad97d6512bb"
    sha256 arm64_big_sur:  "15c53b9a973cc9a30259c1cf3705f609dc300668d1a80f3185bbc174140350bc"
    sha256 ventura:        "8e1e3a0d3c6164276bf1c76bf260ae4a934ffe7b9b28c432b7b673655658e01f"
    sha256 monterey:       "00b2f81b3b7d7bd8530ae3ce7e7267a656207d7727f40e8f24d2d7c8ccd62f7e"
    sha256 big_sur:        "541bd0c968dcd286fdecfa3fcd578fbb82292a7fc8a4832f9ac8d81ee7e1f49f"
    sha256 catalina:       "924bc54083a27ace9c7d58161c8100b44918eb0f772f0452c69a02fee72bdc58"
    sha256 x86_64_linux:   "3f9be474e54109968728d0d43089dd7a230132f089ad77139860101800abfa64"
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
