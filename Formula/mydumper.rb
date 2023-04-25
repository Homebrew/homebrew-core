class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.14.3-1.tar.gz"
  sha256 "aafb9c0914b720e175988a41d9c340271348e50e3a00556035a9c4afcf80c982"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(-\d+)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "97841b65e98c86816317ade0b7948595b66bf3f3a3f02d63f7b581dc2f9b3a89"
    sha256 cellar: :any,                 arm64_monterey: "445bc37997fc5bda3055f705a0b11fbe187c173bad4609c54b9de6bc5f0c6767"
    sha256 cellar: :any,                 arm64_big_sur:  "c4448b208412ef840651f6f75c2483eb94166d850f1485dfc9b8e2710140629a"
    sha256 cellar: :any,                 ventura:        "4c09d4a3f95ac4c12f7e8ea6c16c31650578df36b00523da4603ceb697e7ba40"
    sha256 cellar: :any,                 monterey:       "e78b37d868026a1d93d6282e81beabb3cf9f3121dee93b8583aadfef37ae1c84"
    sha256 cellar: :any,                 big_sur:        "b400c0e5d844da2dbff4d393ae5e03166bad97eb02f12344211326743f8038dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c135cb9985c0378dcf8ce2e614539124dbbcbbdfafd7db719c288b372a7574d"
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
