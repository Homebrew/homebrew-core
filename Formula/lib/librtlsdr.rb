class Librtlsdr < Formula
  desc "Use Realtek DVB-T dongles as a cheap SDR"
  homepage "https://osmocom.org/projects/rtl-sdr/wiki"
  url "https://github.com/steve-m/librtlsdr/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "f407de0b6dce19e81694814e363e8890b6ab2c287c8d64c27a03023e5702fb42"
  license "GPL-2.0-or-later"
  head "https://git.osmocom.org/rtl-sdr", using: :git, branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e190eb8b02ade5f5be5b15fb07b11ca2fee5a586597a279584e1198341c1cc2"
    sha256 cellar: :any,                 arm64_ventura:  "d8c24145ac1ceeea136217f23f2b887b95dee7e3fa174384e2bcd1aec5419f38"
    sha256 cellar: :any,                 arm64_monterey: "84c6e8c711bbf3c97c2b926c87d417558a164cf5870ccd9fe5420ac2d37cf1e5"
    sha256 cellar: :any,                 sonoma:         "d4060f4b17661ba3b0687dca15ec474989a997c7f45fe4d7e351b62168a04468"
    sha256 cellar: :any,                 ventura:        "e1596383703404db916ace4b3ef729ba1ff6799bd54e5173dc10969c4185f377"
    sha256 cellar: :any,                 monterey:       "1c0aa79a1afcd12f4fabb0384d5378ddd81016a2720ab5907d9405d13d1156e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a862647f13e22312396e83c4122e7bd985fdff0982910734ad7e9334809917ba"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "rtl-sdr.h"

      int main()
      {
        rtlsdr_get_device_count();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrtlsdr", "-o", "test"
    system "./test"
  end
end
