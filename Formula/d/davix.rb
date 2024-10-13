class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_7/davix-0.8.7.tar.gz"
  sha256 "78c24e14edd7e4e560392d67147ec8658c2aa0d3640415bdf6bc513afcf695e6"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d21714946afe6a93d3e4784d2ae1f68ad6b40802d566962180a7bcf77394b028"
    sha256 cellar: :any,                 arm64_sonoma:   "54e5bb08a24253d9e0c4f2e00e04ba10277f02d0608804ed948223e60bad3672"
    sha256 cellar: :any,                 arm64_ventura:  "f6fc0314f5d39d0230400cdab883e8d5b325108403551c143c76eb4568d675b7"
    sha256 cellar: :any,                 arm64_monterey: "22c2d25841190dd02dfb5473b9d57cb7fa0f92ca0c85632863d511fa87eab7bb"
    sha256 cellar: :any,                 sonoma:         "e43d8021be61259e6b69985be4c2aa08650ce2b8b6448ea048447721e4c26a3c"
    sha256 cellar: :any,                 ventura:        "2067b1e8c55e8908b38b3333e2c5fce53d1c72bfc62c3ba43d3b2ed20c667354"
    sha256 cellar: :any,                 monterey:       "120f4c46485812389b5033185e3f9e01f7d354aea826606128eff54055c6e3c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aed179e04a6e34773981aba65e9e38478dd18cce9718a4aa599a4301001a1453"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :monterey # needs CURLE_AUTH_ERROR, available since curl 7.66.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = std_cmake_args + %W[
      -DEMBEDDED_LIBCURL=FALSE
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLIB_SUFFIX=
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"davix-get", "https://brew.sh"
  end
end
