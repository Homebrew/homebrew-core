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
    sha256 cellar: :any,                 arm64_sonoma:   "ceeb99cdfb5f7bbe0057108f8178dcae452935349ac02202174cce8f7e470cb8"
    sha256 cellar: :any,                 arm64_ventura:  "36cde4a8d16d6d358057bf683c6b16187c32393879adb102b406567a33b5a3c9"
    sha256 cellar: :any,                 arm64_monterey: "5e8add3c8b7f1eb4e6815b5cbb2288cc1032b7659c1c458b7a43f9e9762e16b7"
    sha256 cellar: :any,                 sonoma:         "054e4bc1f833d12b4390f0f408e80c6ccbd9506e184dfc060e3dbbe16d1d4490"
    sha256 cellar: :any,                 ventura:        "b449650a112aba9026facb4ea877f36f922f87e4ba31c8d8c4f8f89d271c562c"
    sha256 cellar: :any,                 monterey:       "21fc050a4eefd85839542ba631ce67c8a7ff3d6929e24d4abf7f73d88cf92237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b378a2bfc33870b65d2977cbbc44041b7452863ac14d45b4525521ea2dcb4e87"
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
