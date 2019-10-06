class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  version "0.5.0-showports"
  bottle :unneeded

  if OS.mac?
    url "https://github.com/arduino/arduino-cli/releases/download/0.5.0-showports/arduino-cli_0.5.0-showports_macOS_64bit.tar.gz"
    sha256 "645cf1c8bc1100cc1d1f8082314aeafba0b81a9d2266cadf5a1d86c177adf038"
  elsif OS.linux?
    url "https://github.com/arduino/arduino-cli/releases/download/0.5.0-showports/arduino-cli_0.5.0-showports_Linux_64bit.tar.gz"
    sha256 "e11c08ccba2d198019f905f6aadab1225d92e6718b2c8269887d2b62c6a49482"
  end

  depends_on "go"

  def install
    bin.install "arduino-cli"
  end

  def caveats; <<~EOS
    arduino-cli is an all-in-one solution
    that provides builder, boards/library manager, uploader, discovery
    and many other tools needed to use any Arduino compatible board and platforms.

    type arduino-cli --help to get started
  EOS
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")
  end
end
