class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/maxbube/mydumper/archive/v0.11.3.tar.gz"
  sha256 "ddd0427f572467589cdb024a4ef746d30b4214c804954612f4e07510607cf7a7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3809c5584af68614529990810504ec3e5b754b103efbabbd2183ec2c6f02986e"
    sha256 cellar: :any,                 big_sur:       "81640fc32d0cedf6ee428fdede75452f62b0404bc7195b15df1a52725d01c57e"
    sha256 cellar: :any,                 catalina:      "2970e1b0cbe118d91cb28cbec52da2458debbdce93dc87c48009225b6c4fa3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe0119b21d41a1bd02dbd16a8a7e3fb9682e00b820e948a8d08e635a30dfa75e"
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
