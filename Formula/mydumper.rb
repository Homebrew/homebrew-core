class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.5-3.tar.gz"
  sha256 "2fc5af9643a27eaca0a2ab37ba11ccac4d82f20bd8a9c14c886961453aafdf24"
  license "GPL-3.0-or-later"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e5599dca1e1ab5f7f591c8f6e3e286561065925c8413df446c1a497c34e3fa31"
    sha256 cellar: :any,                 arm64_big_sur:  "02678d600f5e9f5b61c97f86257b17bd4ffeb16036b1f7018fbb14a09d506aee"
    sha256 cellar: :any,                 monterey:       "5abc3e7f947d591430d659bf00126e37e6ab10865e25102dc3e64d71814eaa5a"
    sha256 cellar: :any,                 big_sur:        "38c194f3ee2c16d038ad3f8d0201941d88ad31aa17b9003623b9e4a652fbcab3"
    sha256 cellar: :any,                 catalina:       "d596ebed1de4da2c66302bf26edfbafae0154bfd911b5909d142e12469f80eb5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

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
