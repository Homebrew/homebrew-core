class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.14.5-2.tar.gz"
  sha256 "9875c262e4a2390d5ca9dfa4d2aa71236b78ad4d0da292634a392c93a8d5f9b9"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f718cc8f61eb297454946a3c14271591fc09927d393666fd2545542f154fa05f"
    sha256 cellar: :any,                 arm64_monterey: "c614bed0f2f6024296cb230748f79442cb932188e908e7eb51b4f6c1130ca4db"
    sha256 cellar: :any,                 arm64_big_sur:  "ebc20d3e1f4990d276e16d2e13126d47407097bfaf181f23128991652b197178"
    sha256 cellar: :any,                 ventura:        "7da613f678f3ed3f679f3575a2f545540ed89dbb8ab27617df286a4197bd153b"
    sha256 cellar: :any,                 monterey:       "dab5105ef6357baecba800478e65192a82fd2ce6bbdd4176cc236e84490c1e3a"
    sha256 cellar: :any,                 big_sur:        "23f4363b1e168c959844dd13add56c573e1ee6e69d9148e5d583a2e66f2b3fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46208f34fe13bc20443399deb6aeefce335a20bd032d1029b9f596368e7a3ad1"
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
