class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.5-2.tar.gz"
  sha256 "809b18dc038c129262c8d6da3377f62253d074344410667fb18f028ec066b87a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2cec383bdec7ab5771d5d438af26659dea25b376020074acc4cfe087a7b386ad"
    sha256 cellar: :any,                 arm64_big_sur:  "a2c87eca5ee9165e393ddeece8cba4dcd67f96d86ce47420c71317c90eeb6bff"
    sha256 cellar: :any,                 monterey:       "bd5b98ca85c8a0dc4e4198ff3ef495cbd821a095bb566eb46078e15779012067"
    sha256 cellar: :any,                 big_sur:        "cd93a90c2cb529e5d1b98bd59d165d61adb72e6b7bc6cbc21a126c332b632747"
    sha256 cellar: :any,                 catalina:       "85aa1058d9c66e3983f46947af2ede75d1c9df90957bd79d808c552d4bc9d87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a97edfdc2faf62ed27952f39d0cf760891a9b5d55d1115e7951e9abc5689e061"
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
