class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://www.nongnu.org/avrdude/"
  url "https://github.com/avrdudes/avrdude/archive/refs/tags/v8.0.tar.gz"
  sha256 "a689d70a826e2aa91538342c46c77be1987ba5feb9f7dab2606b8dae5d2a52d5"
  license "GPL-2.0-or-later"
  head "https://github.com/avrdudes/avrdude.git", branch: "main"

  bottle do
    sha256 arm64_sequoia:  "5f07f2d83f042eb50e5c8deb859da2ea9311e1e64d85f019447812c5d2b8502b"
    sha256 arm64_sonoma:   "486585890c5ab7dc3c57e3be076e65d4a050c34cc3becbbe74cf257e3f8b0ad0"
    sha256 arm64_ventura:  "b2076d454725e67bda7bda9c14273372bc75b58cc8d8ca05402d7e05127a9997"
    sha256 arm64_monterey: "2f5a803452cacd443bdbfb32acf4c9e25f43222518db5bf2cad81712dde50da2"
    sha256 sonoma:         "b3da9285a6b2c4d0a490362f3536e95e7364bc8ba95112b2eab123c69c3bc393"
    sha256 ventura:        "97d2a1fb9eab66186bb32320c0a4be603e22dc79271cc92f8c858ce818651120"
    sha256 monterey:       "d7f62c95f739d8fbeb35d45db9f3b49732e68df5d5bb99ddb19a156ed1e6971f"
    sha256 arm64_linux:    "9985c193d4ab02a2cda981313bf94228b7668a3e5c508cf7bcf5c8539def4127"
    sha256 x86_64_linux:   "6a89480ec589d1823abcb3496619bca89e257b914815b32f00b225e45beea62a"
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
