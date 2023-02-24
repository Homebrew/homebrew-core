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
    sha256 cellar: :any,                 arm64_ventura:  "f9d0399d6546e4a569357be3ba4adc5e98fd7b479b5d875b1eab8b7a349fc2fb"
    sha256 cellar: :any,                 arm64_monterey: "8546f36aa8d4134fbdef844a58d775393b9ba0f813278a76915c09b4e957b1eb"
    sha256 cellar: :any,                 arm64_big_sur:  "b18d57dfa7aa4858daec3262cd12b985bb3669564e0ccc5376b10ae9928754bf"
    sha256 cellar: :any,                 ventura:        "8de1e2cca7f034cb9f2012f054e867e40d18de06d6a77a160e52cf0bac3c2714"
    sha256 cellar: :any,                 monterey:       "dfb013ebcaddd738506116e24586e34b1126a365b573a788069b5369a07d2d65"
    sha256 cellar: :any,                 big_sur:        "5d3de84749cc16515080f4d3ac83a74b6f2625de302a06048d6a0acb57f6bd8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ec645166cdcc637419479145f4441ea42c8604bd7f529ac2e6eac9b7e3732d2"
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
