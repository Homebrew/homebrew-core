class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://www.nongnu.org/avrdude/"
  url "https://github.com/avrdudes/avrdude/archive/refs/tags/v8.2.tar.gz"
  sha256 "72fbe49d3e3ea2f48a750e7f2c16287b163a580e020f745af39d45ba68d9d6ae"
  license "GPL-2.0-or-later"
  head "https://github.com/avrdudes/avrdude.git", branch: "main"

  bottle do
    sha256               arm64_tahoe:   "6cab251351fa871a8dd37179e54cbd276143da646b4cb286601b99f42857c0a8"
    sha256               arm64_sequoia: "20e5cc4a9a1bdedb9f0013c5796982e8d7b6c084ee33b5c9cec2ebe971dc9b94"
    sha256               arm64_sonoma:  "7931b94d9c96909341e347af164712d0b231f952f09a44db5dc24bdca8e64ecb"
    sha256 cellar: :any, sonoma:        "38ca28b7326fbd67ff857c29dd320f7c7418d8dc65d3c7f2306db8474caccac9"
    sha256               arm64_linux:   "3f5fa69f0eec23f6ed6cf7e7f7e9f2c9bb9877840c5be6cbf6a1f4c75b85fe05"
    sha256               x86_64_linux:  "1a54e3b9abd22ff955023108be92d1c50c79d631d704cecbf8989593fb94a169"
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
