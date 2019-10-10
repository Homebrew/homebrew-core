class Librtlsdr < Formula
  desc "Use Realtek DVB-T dongles as a cheap SDR"
  homepage "https://osmocom.org/projects/rtl-sdr/wiki"
  url "https://github.com/steve-m/librtlsdr/archive/0.6.0.tar.gz"
  sha256 "80a5155f3505bca8f1b808f8414d7dcd7c459b662a1cde84d3a2629a6e72ae55"
  head "https://git.osmocom.org/rtl-sdr", :using => :git, :shallow => false

  bottle do
    cellar :any
    sha256 "8d09d3c7765995caed6f1e8fa26087e345d178c630b1ef2057fb8c34cdcddd7d" => :catalina
    sha256 "0e9b14804b722d9efc959940e40ebcef7bf716eb636f0bb0dc600770cb005531" => :mojave
    sha256 "71f28a8abd8e9e0245a61f841fcebcb7a179d952be786199bf21fae0edd11f6c" => :high_sierra
    sha256 "d1b83b24f32d4857205be289f7c632ee3bd77af802e3445d7565bb9ba9e4f3b1" => :sierra
    sha256 "f5196572498f20ff0ea38d4e7ceed95aea1199a558f29dd6aac5cec9db65ce33" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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
    system ENV.cc, "-L#{lib}", "-lrtlsdr", "test.c", "-o", "test"
    system "./test"
  end
end
