class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.15.1-3.tar.gz"
  sha256 "a25bcb283b2eab192640da2e55ab7798d92293693bb717fb1490d59bc35887ee"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e76c16211b4c38989db3cd42bd8160feb2c1fa6ee0b040aabcac5ca4c0e5dd4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6a34014c31b05f49d41924fb324c278e103b662eb62f33129002e7fc301390f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db7932dda55b7c2966653d52bb8e1f39e54fec008f81b17a4528ff44451773ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "077fbf649c4eba232a578647a2fac1312c4ae7ec46c4fe14ad11dda3b3369528"
    sha256 cellar: :any,                 sonoma:         "301fb4f6bc834227bf8c942ca843be8788bd2f9bbf17bddb2985cead1babcc2a"
    sha256 cellar: :any_skip_relocation, ventura:        "44135487d0d21e3a247426e5383560b7f6de82cfe8dea264ab46a9e08ae76336"
    sha256 cellar: :any_skip_relocation, monterey:       "11da5157606945cf92a6714e22aad18900ea42f87eda51239ccedab3e5f5062b"
    sha256 cellar: :any_skip_relocation, big_sur:        "169d62b34e47c949b31f39d49d480d6a703911256b052c44c6c9b12f2b6c60a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8a4f765bffc08b76ce6ac8d86930460305d95daaf7861bc15d8c46fc00298e3"
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
