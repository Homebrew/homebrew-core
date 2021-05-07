class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/maxbube/mydumper/archive/v0.10.5.tar.gz"
  sha256 "59107ca92fb7ca3ca3a7f3b0fd4cf3fd036c6ec9c16e0cec23647aa416f01861"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "455f95559b2dbe864afba6e25ca4632c08ea01427d893e6b74da705f6ddc3df6"
    sha256 cellar: :any, big_sur:       "cef3fb7db8b705a3aff4a08105637454015184774d0a967e5ad012a176e5c76f"
    sha256 cellar: :any, catalina:      "dbd667367fe99a0b5ae562554dc8a8b83d6d66f53be8ab6279dbc52c920c7115"
    sha256 cellar: :any, mojave:        "8a774ee31ebfcf66b836daeb7e45150040276ad0bde488a4699908bc17bf8663"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args,
           # Override location of mysql-client:
           "-DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}",
           "-DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib}/libmysqlclient.dylib",
           # find_package(ZLIB) has troube on Big Sur since physical libz.dylib
           # doesn't exist on the filesystem.  Instead provide details ourselves:
           "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1", "-DZLIB_INCLUDE_DIRS=/usr/include", "-DZLIB_LIBRARIES=-lz"
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
