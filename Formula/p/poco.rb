class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.13.3/poco-1.13.3-all.tar.gz"
  sha256 "4ddb6a8f8c7a2f190eacb27d886f3913fa945cdbd2acd2d66029a0ec7ff06af0"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "96a50f8923b4699d1890b3fc2827735e228d28c18dc86468281b8e09bb83ffb6"
    sha256 cellar: :any,                 arm64_sonoma:   "0157b0a09d116cf06b48a3c72b1881b1fbbb5ed8381b3d33d610e8a52704889a"
    sha256 cellar: :any,                 arm64_ventura:  "14578602e8263f409f53650f350f1b12604f0b1c5d383a3cbe725bb013d33e70"
    sha256 cellar: :any,                 arm64_monterey: "0ddac0c410ae4736c2b3f08f573a3469c2c1782f3e0319961ee9ced46243a7ca"
    sha256 cellar: :any,                 sonoma:         "7780757339153f4bcafbc573136672ccb00919940873637d12ee511a7be6b737"
    sha256 cellar: :any,                 ventura:        "2af274bec83cfe072d1f5dece0f264547c92d00d7f1eab53f7171b5f3e39f365"
    sha256 cellar: :any,                 monterey:       "a3186ef99d124cfe0d7eae11982a5fac52bbf822aab99350ab3a43ef6fa9336d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c13ac64e439e3d4a95988e224aa85fe8d8d8f22edd989100986022252d4288a5"
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
