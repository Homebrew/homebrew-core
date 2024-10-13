class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.16.7-5.tar.gz"
  sha256 "f554552fe96c40a47b82018eb067168bcb267a96fd288ddf8523c9e472340f2e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab01afafd344106da39e94a2fd3f5b40b0c8633b871c1ce171793e4ccf063251"
    sha256 cellar: :any,                 arm64_sonoma:  "82524194bd826d59c86d251f4d62342d004a5320f019d63fd442eed4a33667b6"
    sha256 cellar: :any,                 arm64_ventura: "0135cdab2a4deea3a7795e15f575debd61f2953b5821d9b0064e47a787342933"
    sha256 cellar: :any,                 sonoma:        "230993daa59054939b8a41c35b5dd63541538bb3876c279fec1140073b87bf5a"
    sha256 cellar: :any,                 ventura:       "033c91c9ddf737c909cf9ba19859bc651cc543ba0ed281d58039b913790749fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21e3a53feac8b1a64daea3c5f82af72e06472402b95cfd930fdc4c35b2ec0a26"
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
