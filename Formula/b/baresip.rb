class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "ffb73d1892c9f6ab6528178943252ae213697c762eddd8fdaab95bbcf6f32dac"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_ventura:  "c5fc965f071fef2e8a65c9034f51c38829eb701bcd6974634fb961ca3b74fc85"
    sha256 arm64_monterey: "a191fdddf5c3e94883812c5418eb83a04784316a7204716d2e90a64a55fcf99b"
    sha256 arm64_big_sur:  "bb9456366e4779fef172547a8dc319b1fdefa91fc0924351714767a835fc9258"
    sha256 ventura:        "3a50795b4790d7a18eb8bfd38ce0ed41d85b6d49071ebe77f2175ac0333e94f5"
    sha256 monterey:       "2b065259318848483c07657cd51aa7eb82a3f34cddcf20af73617efdfe8ed0a4"
    sha256 big_sur:        "2f76f311e8748463ded859df78877e1125e0174a9afd0a66fe0c61d7d10cf30b"
    sha256 x86_64_linux:   "0981c3025a33d4b255f19d03a69846d47a39e7731c701aa5da024b2fefe3fd7d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}/re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
