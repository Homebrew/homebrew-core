class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.3-3.tar.gz"
  sha256 "8c7e3b44f5f4840188b1c32d50e82cdba6c8c735076930b02d1e33581e8447d9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0c0d9517cb9f8655dbbf52a5f4edf6962a57f2d242137f195cc98b7f091e0efd"
    sha256 cellar: :any,                 arm64_big_sur:  "edfb911145782465dd34b447623f24ec77e71050bced091d19fc8adf410cf374"
    sha256 cellar: :any,                 monterey:       "c1c7583669ec8ccb5989c1dd4e06ebe36cf5d561b50e89b27a3a9defd930d28a"
    sha256 cellar: :any,                 big_sur:        "f7b9bb7fa6bb9c5f19df1d4d627344da487725bbfff59d8e6cd56b3be3c01b17"
    sha256 cellar: :any,                 catalina:       "7272a11e00cb105f0a0851e3108885f8e0aca661d8150f2806755c9d6f59967f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4266b7209ccb1255c72ffc20f7b0f8ed20921cf921dd1a9c9e80669c2c9963f1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Override location of mysql-client
    args = std_cmake_args + %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}
      -DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib/shared_library("libmysqlclient")}
    ]
    # find_package(ZLIB) has trouble on Big Sur since physical libz.dylib
    # doesn't exist on the filesystem.  Instead provide details ourselves:
    if OS.mac?
      args << "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1"
      args << "-DZLIB_INCLUDE_DIRS=/usr/include"
      args << "-DZLIB_LIBRARIES=-lz"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
