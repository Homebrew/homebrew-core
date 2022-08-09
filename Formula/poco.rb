class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.12.2/poco-1.12.2-all.tar.gz"
  sha256 "642faec888acb619954d870f89c12a834052813306ff8d8a071becb1eee708aa"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "88b995a64de97693d537804161d50998b437d1a58951ebbfe0904b94f2a0f52f"
    sha256 cellar: :any,                 arm64_big_sur:  "b5dce1561be3c015b874bd2e74d8957d19ffea3a831b7a374cf72159b8e3dd19"
    sha256 cellar: :any,                 monterey:       "d76fd3c8ef048d331763b8ba3799a2c36c19bdeb128100db880471fc53db2d90"
    sha256 cellar: :any,                 big_sur:        "7f9a2cf3c0893e040853c3c976b36c24f4d951c2e26ce0545ca7379e776ecdd2"
    sha256 cellar: :any,                 catalina:       "5f1ae6eedacb81fc1caa8d4af3242a365c6f1fad108cc0e2c51cb62ffda12786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ced86c276a3c9380f72c3379553e9bf99065dfc542b2c2528957f8397f705167"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_DATA_MYSQL=OFF",
                    "-DENABLE_DATA_ODBC=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPOCO_UNBUNDLED=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"cpspc", "-h"
  end
end
