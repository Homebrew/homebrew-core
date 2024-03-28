class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.16.1-3.tar.gz"
  sha256 "ba5defbed572ac73f7cd2faeb2f0132bbcf72ce44d3159235d3b8b2e2c9e792a"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "345650ec3dfa0c864a24ebf1977e8260154ada0a78a2d7a9c340114830084ffb"
    sha256 cellar: :any,                 arm64_ventura:  "893bb953cdf56aec43abd6d5c94bf9b60084b32333dc53795c9a722f6f4e22b5"
    sha256 cellar: :any,                 arm64_monterey: "95cf4e8f5ed62e1f7bd4c9bcd3eef099f51add0a1ff1d1aff3a517cfd0969507"
    sha256 cellar: :any,                 sonoma:         "6be7959782f3d692d37b10efe4fce2eaf2e23f61f60a2ba4ed90bcc4e4c6fda7"
    sha256 cellar: :any,                 ventura:        "5f78a95e16f597b0e81d1915ac4db009bb3a3be2bab6c7456df5809e931ec097"
    sha256 cellar: :any,                 monterey:       "54e4fa5ec30cd927607dcb1e66b798525064a5acb23b02d538e44ba71f2047ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11c3f576177bc1330c87d6f38595e7a281a17c93e171029c89a6875d74b954ca"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "pcre"

  uses_from_macos "zlib"

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
