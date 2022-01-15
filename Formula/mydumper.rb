class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.11.5-2.tar.gz"
  sha256 "5ca8fbca52abaf42d0c21eca2a182772a958709b3b150bfd3c10a47496591727"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4dfb19abc4e7db792c7b501071835421094a64396d761d30df17ae773dae8185"
    sha256 cellar: :any,                 arm64_big_sur:  "765dbe26bae2ae4123d3a090c04af0270850c957b211a7373b726bb33199fed1"
    sha256 cellar: :any,                 monterey:       "eff12ff418e7c254a6114334bfbc28f365b6a7a96904881113f2fbb9cdb664fe"
    sha256 cellar: :any,                 big_sur:        "00d4f78855de61a05480d9a41d7250163845606794feb62527fe4047f61a3447"
    sha256 cellar: :any,                 catalina:       "c92f8d54ee96ba590e0cc348ec6864379c90bd36f99e89e5094d6ca1ccf5fac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6ce78aac922befc587ee513943be1749fb3524224c5bb3da5cb9c79ef27778b"
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
