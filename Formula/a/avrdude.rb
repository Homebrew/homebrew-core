class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://www.nongnu.org/avrdude/"
  url "https://github.com/avrdudes/avrdude/archive/refs/tags/v7.3.tar.gz"
  sha256 "1c61ae67aacf8b8ccae5741f987ba4b0c48d6e320405520352a8eca8c6e2c457"
  license "GPL-2.0-or-later"
  head "https://github.com/avrdudes/avrdude.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "7e4fbdde7efdd2122c7668c7ad8997c58c6f84577cd9622677eb2c09e0db486e"
    sha256 arm64_ventura:  "bc150a18a9b486d40092753d452d0a0fe173119bd98802ad8172db2415037b10"
    sha256 arm64_monterey: "ac3825a0b78e9fed3a9dfe7953e12acb618d0a3d7e673619ec6bd4663841d553"
    sha256 sonoma:         "9e6846073cf666e0a608664c59b107fe06f070556e6518c4abc686cd58088029"
    sha256 ventura:        "10c38132dbad1e5e8e23c6ed78141c6ae6944c525ecd998be82ae1ecac3b47eb"
    sha256 monterey:       "37df39cbb3b4add3d85cd25ed881f61915fbb86692f37068b00ccae08f2ad95e"
    sha256 x86_64_linux:   "772d0a3a6827ee7b7784c36c69075c444163874ec2aa6848f036efac2a582825"
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
    assert_match "avrdude done.  Thank you.", output
  end
end
