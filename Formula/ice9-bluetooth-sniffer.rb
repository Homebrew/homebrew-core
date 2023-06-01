class Ice9BluetoothSniffer < Formula
  desc "Wireshark-compatible all-channel BLE sniffer for bladeRF, HackRF, and USRP"
  homepage "https://github.com/mikeryan/ice9-bluetooth-sniffer"
  url "https://github.com/mikeryan/ice9-bluetooth-sniffer/archive/refs/tags/v23.06.0.tar.gz"
  sha256 "2fc322c18b775cb0d6101efb24d09aea80f758f26e0772820a4595a7d8313e99"
  license "GPL-2.0-or-later"

  depends_on "cmake" => :build
  depends_on "coreutils" => :test
  depends_on "hackrf"
  depends_on "libbladerf"
  depends_on "liquid-dsp"
  depends_on "uhd"

  on_linux do
    depends_on "fftw"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "timeout", "--preserve-status", "2", "#{bin}/ice9-bluetooth", "-f", "/dev/random"
  end
end
