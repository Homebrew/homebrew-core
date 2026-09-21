class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://www.nongnu.org/avrdude/"
  url "https://github.com/avrdudes/avrdude/archive/refs/tags/v8.3.tar.gz"
  sha256 "6c6fe3606f2ef331e502fb9c1d418ba09eb9705e811efbe18259025a9787ee3d"
  license "GPL-2.0-or-later"
  head "https://github.com/avrdudes/avrdude.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "0ba01d7b32c136a2281e74ae06185066579fea5aad59903eef3def364132182b"
    sha256 arm64_tahoe:       "f2f74daf7772910b888c482b0d3ee6f92506ed9c1518c67cc41ee2bd43ecbf35"
    sha256 arm64_sequoia:     "b52edab65d14b4e34784484b1cf2917486acf4c6258741e72321d88c85f3640d"
    sha256 arm64_linux:       "3a5a2c28b97bce411b218f43096cfeb46e7e7a76af9502ec2d6a883ae0bcaa7c"
    sha256 x86_64_linux:      "13aa443020c8f4a95d45893e3eeaf32bb275bd5eada590bfd5f45c688d468e6e"
  end

  depends_on "cmake" => :build
  depends_on "hidapi"
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libusb-compat"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    # https://github.com/avrdudes/avrdude/issues/1653
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
    depends_on "readline"
  end

  def install
    args = std_cmake_args + ["-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"]
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *args, *shared_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args
    system "cmake", "--build", "build/static"
    lib.install "build/static/src/libavrdude.a"
  end

  test do
    output = shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
    refute_match "avrdude was compiled without usb support", output
    assert_match "Avrdude done.  Thank you.", output
  end
end
