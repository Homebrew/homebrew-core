class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli/releases/download/0.5.0-showports/arduino-cli_0.5.0-showports_macOS_64bit.tar.gz"
  sha256 "645cf1c8bc1100cc1d1f8082314aeafba0b81a9d2266cadf5a1d86c177adf038"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    arduino-cli
  end
end
