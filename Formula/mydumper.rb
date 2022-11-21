class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.7-3.tar.gz"
  sha256 "28701956a2d6793290592cab36eb9ca6d5764a62845203fdfde4549c7acaa2f9"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(-\d+)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d531126bc2a58d6e4b2bce6d4ddc76bf00444c8308a8b40f7a476e6f6d118bd"
    sha256 cellar: :any,                 arm64_monterey: "70b1477d5ac79ccba9f262994616bf7fc0d574acae10c9ed3a329c1d2ce0b6db"
    sha256 cellar: :any,                 arm64_big_sur:  "431f5b4b94f1887cddc0f3d46eb1f1883351c7d1a49d62163f40a67767f57edb"
    sha256 cellar: :any,                 ventura:        "d7f242fa425c6464f2b1edd3a376cd24c2254351bf0c2a7cd9ed20cb3e2cea84"
    sha256 cellar: :any,                 monterey:       "6c7247025d4dfe2cf643cb25fd5abd88de7a4f5d5514902ed5f98d7356e82981"
    sha256 cellar: :any,                 big_sur:        "efc50499675ac124c4496be1072443584cb7d115a7ff7db5617d401940d425bc"
    sha256 cellar: :any,                 catalina:       "adb864ab56386526f3dee82dd26d15272d7e31be07ef454f81982b62df0e67c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21b9becb8d297ac64f5bf6b320d81894509ba9ee6e27dff4a33d218061fc203d"
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
