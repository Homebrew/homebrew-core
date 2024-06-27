class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.16.3-5.tar.gz"
  sha256 "88cf74fc2d47f959cc64681c9ccf7fe98bb5e516556ef38aaf25e8935008946c"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dca4c4e512628e3f5d6dc8713e9a48543cec321e57c4763ab38f0193e8dedd0e"
    sha256 cellar: :any,                 arm64_ventura:  "495cb8365610f919ee09e10b9c162f5b65ca7fbc6ba4b35999befbca83dcac3f"
    sha256 cellar: :any,                 arm64_monterey: "9d3dde901fc82acfe92853755f05fdf25ba0428e574adcb713a5bfac9290a6b9"
    sha256 cellar: :any,                 sonoma:         "1dfba00d1d4aaaba486e1fd62b4feee5781ea9a9190170c123ce3fbcfc4105a5"
    sha256 cellar: :any,                 ventura:        "bcd27969e5a529b4b66dc4300176a78d2e43ec05c17ad9bfed279304364bd19f"
    sha256 cellar: :any,                 monterey:       "0a62beb791f95c596ff17d040c45ee04cb86eb1b14626320bbd768d848645599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31a683ad365e3000bcdc87b6e8f1005ea127871d42667a16e81c5bfaadfaf909"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "pcre"
  depends_on "zlib"

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
