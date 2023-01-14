class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.13.1-2.tar.gz"
  sha256 "85ab85ee51432201a1228bd0db998a00cf5096d73c02bce337c0ed79d027bd92"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(-\d+)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "99d08336ed03e7014d56f7ce4e142a0a92c7ecfd73a000e89f9c93ceba82b079"
    sha256 cellar: :any,                 arm64_monterey: "1add19e1512aebcda3bfc652fd7035dd71d52bf98f239d75ad152d6849aa7a24"
    sha256 cellar: :any,                 arm64_big_sur:  "aa7953ae5747775e4d25e0e049e993b604de6209261e410200e8f57870979d99"
    sha256 cellar: :any,                 ventura:        "9788174460ff6db4d527281099c5a311370e23eacf570e33fe9b7cf6fb0c7f56"
    sha256 cellar: :any,                 monterey:       "8f057b80833272b3282183ef873f4bd68b10447eddf5ecd7b165b0cb5f9a88a8"
    sha256 cellar: :any,                 big_sur:        "56bc760d7a3ae770275db74385415640e3643778f97e185e82ba620b664b9dd5"
    sha256 cellar: :any,                 catalina:       "e0510f19f1ee64fabc8af701a356f55190b00e56665b6ea30662e31689e72da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59649c143e9a8ba09c2f4ed19e2585bf838447117f06e0226f462d58f738a7ec"
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
