class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.3-2.tar.gz"
  sha256 "6f3fbb6d1d85ad4dcecfe753af0c176ddf10c67e547cf8dba4556ff7c0eedebd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f8dcdf00e92dd854349c1e0698934c8b337c38ea653288dedabdf1ad61c916b0"
    sha256 cellar: :any,                 arm64_big_sur:  "66b108fa2909b02a98fffa1197270f6cf5a3c5b46c8c648940a42a2985abaaad"
    sha256 cellar: :any,                 monterey:       "62168e340cdfc0d1fdc63831218b52ad3a2cab6c723e21277a837451139574ed"
    sha256 cellar: :any,                 big_sur:        "4c5707d62cf6152d8106e1a17e36b8dc62e67663045bd29448b8f50cf8f92ee7"
    sha256 cellar: :any,                 catalina:       "ca473525bb5b1d3ba3fc2917c38235afa930536fcca4b83b4d57c7d14d1529ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdce77ac9629c4dc3f624692de449bf9c144a1e9f0f789c20abe13f2ea7e6c57"
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
