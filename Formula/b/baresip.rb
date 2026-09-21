class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "e170ad5857994dfed0c84c4c04eb904fa410f3ec2d5a6c789b50b3fda47ba98c"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_golden_gate: "bc051029f9c6e8dbcfac25f652ae23a3d9c721570cf88c96fa988681cef3d7fa"
    sha256 arm64_tahoe:       "40c9520cd69893e56e6046e10e035196568c6baf09fe08f090d3fdc490f2da92"
    sha256 arm64_sequoia:     "370a7d08ee7c31c06a492aa64dbe3215346cae69ede1824099a1dd77630a4eee"
    sha256 arm64_sonoma:      "9b26add3c82d656d831d75ff31761d8190479041d13b7b910198f377ba307b3a"
    sha256 sonoma:            "c55215d6f13b4a53bd8d5503d0e2aa6bd04a892f879ab4e8b124ab20b8cd4b39"
    sha256 arm64_linux:       "28362d656809541607b82679094966019090aff492212729a5bcd4fe64d8aeca"
    sha256 x86_64_linux:      "0f5215e5362343c1dd566aba13c1e79e27ea823363b2c73ad2c9aa75fbdc45d9"
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
