class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.7-2.tar.gz"
  sha256 "3da2cb83129745ee43e5874e24f6c355a140fc6a45d8dd97ec731ae6b5d4a233"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(-\d+)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d0d623b442dcc05cd7d591040299f842494c973edcb6a99f5468c8e6b3e436a1"
    sha256 cellar: :any,                 arm64_big_sur:  "d2d609c6de453321523b12dac08c3cadf8af7511b254ee5dcc85f10004852713"
    sha256 cellar: :any,                 monterey:       "553487bc55ed8ac2f9b26b5a4d45333dab979516db44d5ac965dfadf06c94c30"
    sha256 cellar: :any,                 big_sur:        "09f043fe37a1407a0d94ccc9c3967f8380a762e104929ce8f1babfbbd5a14fe5"
    sha256 cellar: :any,                 catalina:       "a7b27b1d5ef09c5f85831b72438929f3ca740ccc2f437718e8cd4f61633b35ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9cdb8e2481935a1663db42d387334dc3fd62a6a4fab55e902783167d6f1a9b9"
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
