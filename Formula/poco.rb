class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.11.3/poco-1.11.3-all.tar.gz"
  sha256 "a7aabd1323963b8b7078b5baa08a6dd100bc336287cae02fae14b02b18ec0aa3"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ceb089e9ecd25c061c152aa98361d2b6bf35c2d325f67011757856bfad799f84"
    sha256 cellar: :any,                 arm64_big_sur:  "408ca613c173e18e83e3cd7bd91f77891008a4ae541bf21d3b56fd6da0a767b3"
    sha256 cellar: :any,                 monterey:       "fee25ab18fe61a6bc1b374405af87313df13681698ead51daaf6676bf9c5058d"
    sha256 cellar: :any,                 big_sur:        "d8673bd7a4b73878b5ddde1f8cc644504930fab2eea34bf3cb0ada0afc4cc1a0"
    sha256 cellar: :any,                 catalina:       "8f9b949124fc70faece5b3eca72ee86183e86592344053240d89dfa0b6ce88d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fc2f8a54507ebe1b36dfa7d60a1de775cae31b637950a00d41885e62de3d4cb"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"

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
