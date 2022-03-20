class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.1.tar.gz"
  sha256 "f3c8ae09573d9a37512984cff24ade1cd87b50ae772944ef57d5bd1d5fac8e5b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1b5775db59b7afdc5821c245ccd20b214a9e1760d8b36f4173ca80e33527cd44"
    sha256 cellar: :any,                 arm64_big_sur:  "ebe48c1156e99a1209ca674982ff41de8c2a49380094b1507837130fe4cf23b2"
    sha256 cellar: :any,                 monterey:       "3e34ecff130366a6436fbc0dca861029197464d3ef76de7ae60934f5b6aeda16"
    sha256 cellar: :any,                 big_sur:        "d6307bc91803d6680e5abe8a499220d0d985cf3cb478007bed779a3e03c2d32a"
    sha256 cellar: :any,                 catalina:       "55cbd0a63b2b428da5dd2b86f1606de09c5956e673c065631d70aa2d97251ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "473646f2e36fa509d131815a3cda025eab73b8a31c5efd72c70ccdb0def099ca"
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
