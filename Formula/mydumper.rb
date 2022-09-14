class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.5-3.tar.gz"
  sha256 "2fc5af9643a27eaca0a2ab37ba11ccac4d82f20bd8a9c14c886961453aafdf24"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(-\d+)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "23abb2679cb427ac27a21eb2f861b2ff0e8473ca15ade8b8b2aae766942b2068"
    sha256 cellar: :any,                 arm64_big_sur:  "bd42dee562319e238547fb47b353c46518f54ca910102e11e91f878dc5ad0c6d"
    sha256 cellar: :any,                 monterey:       "4b5b22ba08c623652029bd995fed1e112132f82822eeff88e1e517e9ac43a44d"
    sha256 cellar: :any,                 big_sur:        "79fd187e0ea1718a17906ceb42e9bec17d72ca6541525d07c699c0460360eef3"
    sha256 cellar: :any,                 catalina:       "1bb198ec53aad994d738ef05fa09cd6ae6934b5eb5cf66a8846daa7a2d466b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd736845a3b6f890ba712dae3ddd4d555373b18815078dc037619bf160da320d"
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
