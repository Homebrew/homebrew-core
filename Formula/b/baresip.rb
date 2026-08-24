class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "f5d4a7d0723b468028dc7581708a660042c909b2cdda4f6ee977f583ddccbc3b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "8fb7609986884ec0de0acd89d9701f1d3051ceb9e4f5d32a1fe09ffb9a1a1c77"
    sha256 arm64_sequoia: "449e4cbfba23a4f09f4fe2145351f3189d8509ef13531ae6feb3598aaa091566"
    sha256 arm64_sonoma:  "6e02f7bed0baab527a3061d560b60eb4920e33d43fb96cbf2bce0f8b5dcb5d67"
    sha256 sonoma:        "22a332fde710e4e5dbe1816954572058a2afd61f6b6f46fd4309174c53d0d702"
    sha256 arm64_linux:   "211adcbddb242ef1b155dd0c752cab3775890df15aa4a6fb6fa218d35f74b15c"
    sha256 x86_64_linux:  "0ea21d0f729e8438d236a1058e66793ca7c76a483b48aacd506c37ccfcf10ea6"
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
