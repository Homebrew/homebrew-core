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
    sha256 cellar: :any,                 arm64_monterey: "52e25f9e15662296215cccf18fbcd8bec5c636cfac6d5988609bc9e7f2f555c8"
    sha256 cellar: :any,                 arm64_big_sur:  "9a17c272cca529e104843c46d05f7c880a493f2497e6068e9321b45caeb54780"
    sha256 cellar: :any,                 monterey:       "c3b565a11da4599d956ff2693058e40b06ae2141ada58b183c141716879e829d"
    sha256 cellar: :any,                 big_sur:        "77b18141d0efafe8fef4b043782caedea789349824fc4e4d7b4774f6f6220c44"
    sha256 cellar: :any,                 catalina:       "4614f6dcbfd03e219ee91f723febcb406bff1426d151059707c0ad225984b0a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b45c9ffaf075e175c6fa585711016a8f3e39e33172f87b36e62bcf993a688996"
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
