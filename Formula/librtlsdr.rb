class Librtlsdr < Formula
  desc "Use Realtek DVT-T dongles as a cheap SDR"
  homepage "https://sdr.osmocom.org/trac/wiki/rtl-sdr"
  url "https://github.com/steve-m/librtlsdr/archive/v0.5.4.tar.gz"
  sha256 "6fd0d298c1a18fc8005b0c2f6199b08bc15e3fb4f4312f551eea2ae269c940c5"
  head "git://git.osmocom.org/rtl-sdr.git", :shallow => false

  bottle do
    cellar :any
    sha256 "10b4e347bac50849b49f68cabbdf9e7f755a05c334b8170007944fd944c53f40" => :high_sierra
    sha256 "0dbd5ae1ab61bb307851b709a4b345e0f12631eb493960a58082f1b6c65feb44" => :sierra
    sha256 "8ec271a60cf24b2d576ba3f52ef5119a134ccc72a5be8f0396c9e99a731ac595" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
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
