class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.16.1-1.tar.gz"
  sha256 "3219b7c2a16f4ce1848315583090a0b05c1dc781b8cebc2948441c247eb28deb"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "63f33806f9b7f3773e226fd1e3fa283f652ab759fe2b11e0407ab4d70a810641"
    sha256 cellar: :any,                 arm64_ventura:  "4c75a9e14228a8b1d2d698643e2ddf375a68135e24fab8e7aaa0bb8e34fc0efe"
    sha256 cellar: :any,                 arm64_monterey: "eafcde1f1f16be33556fcdab10b28ec8e20bc2354af16f5cd419a61d30eb6e1a"
    sha256 cellar: :any,                 sonoma:         "edf42bc740f34ab16544a60996cd7440de24a3ec3aa83018a0b524c432aea416"
    sha256 cellar: :any,                 ventura:        "511d18ccd6174ad8e602b2072ea5e171a79d8cc574a44958ef91ec5ca8ddadf3"
    sha256 cellar: :any,                 monterey:       "dff49447d88f54fd3497576f563b897b0056ac0038fc843c12be893e2f851df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4332b7c44b0b1e007aa3d4816cf19641be17bd4701463c241c7cc17f3748bc5f"
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
