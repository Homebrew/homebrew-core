class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.14.1-1.tar.gz"
  sha256 "719ea52041ee2c874b1590d6f70cc8ee9b5d604c4088eb11da7cd525da1f0d66"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(-\d+)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e49c6afa598793fedeacebbeed204d0c7c4438cea0eb9b48ec8e027f2b23ab6e"
    sha256 cellar: :any,                 arm64_monterey: "8471552ce37af02c97d33da730f0bcd5a06a70770d7f3ecf2b232f4af524377a"
    sha256 cellar: :any,                 arm64_big_sur:  "d5636d720910922f4ebedbbe78b8b9f9c656f65907007c9d10db441b0ebcc728"
    sha256 cellar: :any,                 ventura:        "fcb809081132170e9d1c09ebdadcacc0fefe8397e5b6916dabdd50bdb161c37d"
    sha256 cellar: :any,                 monterey:       "9c8842f0e7f5f8794256d5152d8f508d704a6b69b0f792b2b687c8ca7486f53c"
    sha256 cellar: :any,                 big_sur:        "cf50ac658ea9a22a833ee822b3ab1ce44e16f8ad35f9ceff96e2ad5743ea5223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a562d636352467c8a6c9590409fb4553cba7a3520ffb8dea43aa0f66a40c12d6"
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
