class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/maxbube/mydumper/archive/v0.10.7-2.tar.gz"
  sha256 "2e7cbd5e22422c418f2803755e1735878c060a2eff61c036799b2fc1443c751c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1921386bcc29a182633c60e570e8cd2fe64bc657a8fd043094bfdaba3066e1d1"
    sha256 cellar: :any,                 big_sur:       "50437e47484abc3294969b9eeffcd8373bc62b53e59636d2e56d2c386192d00e"
    sha256 cellar: :any,                 catalina:      "4bccea5099be96d94719a79360b48ef71876c57c7836a17455d4612817e34888"
    sha256 cellar: :any,                 mojave:        "9e4ca09a18d4bc8d44b64748445bf3dafc32b0d84092e74cb460acac5e898fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27e718cb5914fe9a3c479024351520231515e969e94d4e7743004773a90c5d57"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

  def install
    # Override location of mysql-client
    args = std_cmake_args + %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}
      -DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib/shared_library("libmysqlclient")}
    ]
    # find_package(ZLIB) has trouble on Big Sur since physical libz.dylib
    # doesn't exist on the filesystem.  Instead provide details ourselves:
    on_macos do
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
