class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.13.2/poco-1.13.2-all.tar.gz"
  sha256 "33fe6c0d623e026b026d0ae757e617538428dbb6fe65297196693c78b55711a0"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "928b7b21be91e48d825d6d40c347d4bb3becfb1d393d8899b76501fe804ccd5a"
    sha256 cellar: :any,                 arm64_ventura:  "c937a0028ea14a4b1317fb52269d15dc4e86f1039849c094367753369c5e569d"
    sha256 cellar: :any,                 arm64_monterey: "fcf9dd71b5bb5769d44785619cf4ae21982493a1e3ec6e0fb2f202e59e7e7839"
    sha256 cellar: :any,                 sonoma:         "f51152175daac34fded4b47b7da935f6d3014e60de449db14900b401ef0e4c7c"
    sha256 cellar: :any,                 ventura:        "a1215bc3c7f73db93aae13dc895ac8d8ecad097c80bba04778c7a40f2460ea9d"
    sha256 cellar: :any,                 monterey:       "335bee40261f77c3c55ead0ec6e8cef0ae6c913a72fc42beea97d153e819f4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "860135b6fd730d44706195e427eb656e5e39de5cb6bc630c5dd52b5e74b40448"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DENABLE_DATA_MYSQL=OFF
      -DENABLE_DATA_ODBC=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPOCO_UNBUNDLED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"cpspc", "-h"
  end
end
