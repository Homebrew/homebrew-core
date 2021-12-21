class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.11.5.tar.gz"
  sha256 "834c530ae1982bf5863272cf0a4d4878451ead3af4f3e23db286ffd4471b783b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0b76f39b06fe7d920c2eb887d66b8f973dbc9bcee72050416ebed400e5e5c47c"
    sha256 cellar: :any,                 arm64_big_sur:  "994895cd10f2346ee9ecbb81fb9f00349a79d6a47ce0b7353ed6f4d454685fbf"
    sha256 cellar: :any,                 monterey:       "0f12923ed5a1e58ac730d14930a599b8ac46c86946639ee2ae2826fff97bf8cc"
    sha256 cellar: :any,                 big_sur:        "621d2b1f2daf3fdec0e8cf0043b4827b7481ca4893da7068b1d201a97070f8d8"
    sha256 cellar: :any,                 catalina:       "d7a865fc96e394e9d42e73a8b69e85617f03d517244806d46605fdc352bbf384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5012c978efdd639d94994f3363ce45f9727d20b53c928bc71dda899167e10ee1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

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
