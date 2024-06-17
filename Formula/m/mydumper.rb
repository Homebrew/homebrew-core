class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.16.3-3.tar.gz"
  sha256 "748b9cb084140138f6410273dca4ca17a140900752d66cda0af9075a2c78d72e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5576a7b76461bf0dee68700b8e3b3d334c9e8d1515f86ac4621bc3a229cd88dd"
    sha256 cellar: :any,                 arm64_ventura:  "6fa210efbd2b05d95530bad1f1799b93e29a116065a88dc798ab88a9a1ae575b"
    sha256 cellar: :any,                 arm64_monterey: "6606bb5189707033852305a2981cdd76513c60819179a1a7a6e793467507d3b9"
    sha256 cellar: :any,                 sonoma:         "c110192b2213438b218153e1540ec8ee18c373b85e9f45dfc9d7ada886068733"
    sha256 cellar: :any,                 ventura:        "461670449ef56b8afdf52a1d3bb1817eeab4de98079e42351fe6b84edcef695a"
    sha256 cellar: :any,                 monterey:       "5d8e43de04ddcba648ecff244368f20d7a78cf54df9edc85f707e7375fc095d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9015479c6d9823fef03144c85370cce58039c1241151a6051e2fbe79fc2781c8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "pcre"
  depends_on "zlib"

  fails_with gcc: "5"

  def install
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

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
