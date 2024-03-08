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
    sha256 cellar: :any,                 arm64_sonoma:   "e657b902508f9b52bf912311e94ebadc7040b266513f7b9d6acc38be7a98980b"
    sha256 cellar: :any,                 arm64_ventura:  "0a128dae784f64daf17164ded9cb8e2001b433ee57d7f033949c3d2abd337577"
    sha256 cellar: :any,                 arm64_monterey: "3eeb56ef5ff1b20110e41eabfbe66dfc91a8bf38c6b191ae1f0bf9166c83451f"
    sha256 cellar: :any,                 sonoma:         "a150ab87c571703e005bbee80a33de3b93935e98953206ec2bfcec9a8ef42e93"
    sha256 cellar: :any,                 ventura:        "efc0693360d4a846d132b0f430be365078903486f8ae68f12ae08a9cc702e968"
    sha256 cellar: :any,                 monterey:       "6806f395eedecd9eec18fa449a27da1d52253b2c736d8434ebced141a7d356bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7229c6b97ca342c49f8a7d053753f83366cfe48c397ebdd8b19cdd62b4fd3e8f"
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
