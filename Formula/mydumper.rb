class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/maxbube/mydumper/archive/v0.10.7-2.tar.gz"
  sha256 "2e7cbd5e22422c418f2803755e1735878c060a2eff61c036799b2fc1443c751c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1f86c0904c414620fd5f7223ce325e728901ff4d1c75f84ac253dfeb88f88ad4"
    sha256 cellar: :any, big_sur:       "c680a5cd0368a1a62d0aeb5aa5d36de2535cb2b67bc46621db3020323fb5ba86"
    sha256 cellar: :any, catalina:      "3d7e7785f6e0a456b5fe251ec2887cb66d3b9cf7a02668ba522ae49226cd7fca"
    sha256 cellar: :any, mojave:        "816b1dd45636deeb227bebd1387db705d16bb9bcb702ae81862b99edb01e8801"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args,
           # Override location of mysql-client:
           "-DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}",
           "-DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib}/libmysqlclient.dylib",
           # find_package(ZLIB) has troube on Big Sur since physical libz.dylib
           # doesn't exist on the filesystem.  Instead provide details ourselves:
           "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1", "-DZLIB_INCLUDE_DIRS=/usr/include", "-DZLIB_LIBRARIES=-lz"
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
