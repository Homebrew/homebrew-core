class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://www.nongnu.org/avrdude/"
  url "https://github.com/avrdudes/avrdude/archive/refs/tags/v8.1.tar.gz"
  sha256 "2d3016edd5281ea09627c20b865e605d4f5354fe98f269ce20522a5b910ab399"
  license "GPL-2.0-or-later"
  head "https://github.com/avrdudes/avrdude.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "3a29b8596cded5c9243cf835257352942d4bd1a1466be0423377d3a405940da6"
    sha256 arm64_sequoia: "99d020ca9145a289d74a52ff001e499e76d26a8afed895d8f39d7d92f7327a8e"
    sha256 arm64_sonoma:  "dfb5e436dd7a172c43e4e2929451ca851ff748843276525799736e8605884343"
    sha256 arm64_ventura: "29b9741bb4b29391facdc339173f61273073fbed528d3ca3dadaf804f5a51805"
    sha256 sonoma:        "ace8f271d4765b29bc8717d5ea758fd097e5baf31570b88b84c8d4c35e4984ca"
    sha256 ventura:       "a50ea68b75610e2bd9125cd753edbaeb76447bdbe4b205063fba4843571eabb7"
    sha256 arm64_linux:   "8ccf60c11997fbf0ceaebd78f29516467186ca20a85cf720c815d8e3fd8d7972"
    sha256 x86_64_linux:  "84b6fbe6bd4f0a34e03c159910960f5c3d6f2e82c58ed6bad2c1eb42ae38e342"
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
