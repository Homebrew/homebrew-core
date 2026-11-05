class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.13.0.tar.gz"
  sha256 "688dbb92844340c2dd8dab7d93aaebccb3aa433af9215bb099ca598fafc0e0a2"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_golden_gate: "4069579dd1642f67fc0488b2f83f5dd97e3adc8ccdaf83d8bbdbb2bd191eafb6"
    sha256 arm64_tahoe:       "63bba8620c3f888a896a6c6eb8ef21dd508f8b8298fd2e0eae832d10d8671079"
    sha256 arm64_sequoia:     "17a733bd0b4a1a83a86e36d3a3656df21558f2b51f40155e77067388ea772bdc"
    sha256 arm64_linux:       "7174109c0930bc6eb5c6da64d4bd3db2c90cf61d194d8d94cb4f5f1b3e016717"
    sha256 x86_64_linux:      "ce455dc9a3038c34dbd129c249c63f8f875bdc63059c3d69b6cac9d51160e5f0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{formula_opt_include("libre")}/re
    ]
    args += %w[EXE SHARED].map { |type| "-DCMAKE_#{type}_LINKER_FLAGS=-Wl,-dead_strip_dylibs" } if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
