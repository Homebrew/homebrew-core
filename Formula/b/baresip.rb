class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "fe0dc70640616b5b6814f728af3ce83b4c56dd1d7a9a21658480c305bd092367"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "541c0f92a16b0071959c7ff38b22fc7ec4365d024cf63faf3c4d3c43912efc7f"
    sha256 arm64_sequoia: "b4dbf937d23eccd58ec201fb21bce454094142e2364edbf3ebc08055bd7184c2"
    sha256 arm64_sonoma:  "3853bccc4ed0b8eecff0255adc20c51f1a04b71b3bceac9ac6432743bc9a413e"
    sha256 sonoma:        "1850eb7c8c96b01831911ecedaf31ece824224a44b2b302ab3fd06cbe9095bd0"
    sha256 arm64_linux:   "e568d30c5aa68320353d959f258a8d9a226e54cc96e7899e1ec7a6472ec58cc8"
    sha256 x86_64_linux:  "73dac2b0d02dd9d996f92e810c5272110196d29d70a93aa97b66062b6fe6c3d3"
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
