class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://www.nongnu.org/avrdude/"
  url "https://github.com/avrdudes/avrdude/archive/refs/tags/v7.2.tar.gz"
  sha256 "beb4e0b0a07f8d47e550329ab93c345d5252350de6f833afde51b4d8bd934674"
  license "GPL-2.0-or-later"
  head "https://github.com/avrdudes/avrdude.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "ef1c67093428501338afc705c0a81440cfc5c8d99d8fe2351fe85f3ca227e922"
    sha256 arm64_monterey: "d31e478fa3320f2ea482ee2c7d57faec909e5ef2096d9853d8bef629084d2d1e"
    sha256 arm64_big_sur:  "829d499cf793631d0f67f518056717849dfff7b307900b0882f9cab93929f204"
    sha256 ventura:        "6b43827f0b3c2c287ae61260bbc35c11cedb54a4cd29668595cac7430114312f"
    sha256 monterey:       "f7dc255c04fcfa3edafc24e9c06ae34d02056b48a942d54cbd694fe7ea681b96"
    sha256 big_sur:        "47de68ccf21cc64b8f79c4ef3b829d51aaa65a6df771cdb92401540adcabf619"
    sha256 x86_64_linux:   "46e4de78eef44a5ed518a5ccc622c146449352ebe169b626cecefda53ba7dcb3"
  end

  depends_on "cmake" => :build
  depends_on "hidapi"
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libusb-compat"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
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
    assert_match "avrdude done.  Thank you.", output
  end
end
