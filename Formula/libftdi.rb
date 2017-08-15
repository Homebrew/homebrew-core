class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.4.tar.bz2"
  sha256 "ec36fb49080f834690c24008328a5ef42d3cf584ef4060f3a35aa4681cb31b74"

  bottle do
    cellar :any
    sha256 "540e617ca5d42d5b647d793b433b4c75768b735a14fc33bec8c368cb1de3838c" => :sierra
    sha256 "37772d45b6844929547144cb7afa28efcd77da77a517047a6f2e3f70da108385" => :el_capitan
    sha256 "81a94352b47d901ba85e957f3d1d21f6cf797e3775503fb6326b69d4e30ecedc" => :yosemite
    sha256 "45365f61af1f24bc879361233fd88422f351887e328dcbed803121aa859189c8" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "libusb"
  depends_on "boost" => :optional
  depends_on "confuse" => :optional

  def install
    mkdir "libftdi-build" do
      system "cmake", "..", "-DLINK_PYTHON_LIBRARY=OFF", *std_cmake_args
      system "make", "install"
      (libexec/"bin").install "examples/find_all"
    end
  end

  test do
    system libexec/"bin/find_all"
    system "python", pkgshare/"examples/simple.py"
  end
end
