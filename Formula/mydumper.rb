class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/maxbube/mydumper/archive/v0.11.1-3.tar.gz"
  sha256 "ec5da4b19522f7b78bf546a9f726166d21f64c3f3e534f55a94313ca1208d770"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2ea9625aeb3a88f5020d86090a8807a3f56b2ccb3795958712da3be2e0faf63e"
    sha256 cellar: :any,                 big_sur:       "8341325410e05edcd172e0e0cbae1573669f963b2b6c73545541330d1bb2ab27"
    sha256 cellar: :any,                 catalina:      "b7e08a8d5d013f0caaaa02b5edd7058cbbccdec3bc405d8b245f501d907155c3"
    sha256 cellar: :any,                 mojave:        "f5454f9c700b5301bfa103346a9b72f4a8b976c4b2d2e92d549680ebbb583d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c93815b1bec5065b7937881ed71c6e9c6f431fd7d3420abdb5f8814b0ad19dc8"
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
