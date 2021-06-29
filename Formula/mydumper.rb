class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/maxbube/mydumper/archive/v0.10.7.tar.gz"
  sha256 "880f474ed5c9b068860b61b3e94ff148957bc73ba663738abd7d8c4503548e75"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d01b069b171552816bc0b12add3d67e9e134839dee190fc398482f3fb8d369d9"
    sha256 cellar: :any, big_sur:       "fba6bfbe4601fb579dabe1c3b860b0b6e4afc06b3a542507be95a221c2ab122f"
    sha256 cellar: :any, catalina:      "dc0094b36f61f0f7549a0d428ea4437a78b796dc3cfd10449da69c02abdb4693"
    sha256 cellar: :any, mojave:        "3492ffef28b547f3fe063eae69db3a97d9c3d2e3a11739b3eba6de318c5602af"
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
    system "cmake", ".", *std_cmake_args,
           # Override location of mysql-client:
           "-DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}",
           "-DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib}/libmysqlclient.dylib",
           # find_package(ZLIB) has troube on Big Sur since physical libz.dylib
           # doesn't exist on the filesystem.  Instead provide details ourselves:
           "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1", "-DZLIB_INCLUDE_DIRS=/usr/include", "-DZLIB_LIBRARIES=-lz"
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
