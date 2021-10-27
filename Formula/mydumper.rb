class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/maxbube/mydumper/archive/v0.11.1-4.tar.gz"
  sha256 "44cee8152a5aab172aaac14f32ac5d981c9db1de2f07c8f87502e6aab1efd792"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "74b73ad586874d5a9d684e39700f4a52ea7328281134d52790149a96a14be924"
    sha256 cellar: :any,                 big_sur:       "7b3bd37dceebe656c04095fd5c2d5db2dca6530cfa6cc60093451755c27c7bb0"
    sha256 cellar: :any,                 catalina:      "46445d2702c23e6d29f06cbd337a93c2609249768eb005c336d69b90c3a68713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19424338dc1feca8c6b6fdad39c23f5732fcc033bcb9527da099a4f1155b2cf9"
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
