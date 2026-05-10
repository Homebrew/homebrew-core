class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "fa281d041e6c5d02f9f71b88524ca8fe05b54d37bbdf985f44fb6a034e02a604"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "f7c332c695fdf5364339529947d80f436b45fc79a6b32e7fbbe0bcf24382c098"
    sha256 arm64_sequoia: "fdbd002e5ced64c21986fea1912a530ae8e81fc86cecf2cc497cf5c83ac3bbda"
    sha256 arm64_sonoma:  "a0c1ebfe95f6a47e9489f2e6061fbce17d650ee235352efd22fdb32659e8ba39"
    sha256 sonoma:        "0394f44c924c456689e5727f3861faaf33265421fb24d5ca9fb914cea228b690"
    sha256 arm64_linux:   "21dce109827b01556684e6d05cc876864d6efc8a03628496ebb94ec5cf220b48"
    sha256 x86_64_linux:  "2a4940c3b0372d2f672dca8bb517bc482e7a6a1b8fa9e6e3a64d19950e4c3411"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@4"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
