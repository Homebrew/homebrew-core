class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.1.tar.gz"
  sha256 "f3c8ae09573d9a37512984cff24ade1cd87b50ae772944ef57d5bd1d5fac8e5b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f2dfc4eec193c3d1389cf14cbac0d783b73ea64d0756fe83bab40183cb2b4e19"
    sha256 cellar: :any,                 arm64_big_sur:  "43f8b656dfe5477d82dadc066f47cd1ff256ba82fd29b857d553a4830a1c3b3c"
    sha256 cellar: :any,                 monterey:       "1c847340c3ae5fbfda625fc443e52b3b67e4fa0aeb6c60f491ffd126bdfcbaac"
    sha256 cellar: :any,                 big_sur:        "8bced79b71c7558930b25689fb1e30279d1b931571118d401547a38a6bd309f7"
    sha256 cellar: :any,                 catalina:       "59b3ee4a3ec26d92328c7ebc0cbb4d777c8d26fcc29f33ae314516f01a131f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f202a99215b136efae9562201e38145871fd8071ad0eba987c422f38d06f4b8b"
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
