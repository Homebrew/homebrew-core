class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.16.5-1.tar.gz"
  sha256 "02cf1034e64f1beb45c5a37b6fffb100b2d928d8dd37a31407a6f97c18d36181"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fbb4ce17a024efb4bd7033db10281236a2e1328871ecec778b955ca25368bb41"
    sha256 cellar: :any,                 arm64_ventura:  "0a1bc1806a13cbbbc02d472e79b7d6369b93066571c5642ecbe9a9202beb684f"
    sha256 cellar: :any,                 arm64_monterey: "9031331ed5614e060b959765d6d78856273f3bd55cdddd09fe143536e5410b09"
    sha256 cellar: :any,                 sonoma:         "adb353bb7aa6180f769c78686dabe53306c8b8f513547796ece5a03e828b9a27"
    sha256 cellar: :any,                 ventura:        "7198ea58a45d4ca3c82dbc6d2171b1476407a121c8292d54eaf787dc53b82907"
    sha256 cellar: :any,                 monterey:       "a6c167f4fa35f6adf3bae9a15917436e096b3abc3cbc628795b4829f0dd8e97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1780467f83103f8cbd1ce0a4ac83d5c5d4c81527dc1263ffa698e5c072ae1eb6"
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
