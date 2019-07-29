class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.4.tar.bz2"
  sha256 "ec36fb49080f834690c24008328a5ef42d3cf584ef4060f3a35aa4681cb31b74"

  bottle do
    cellar :any
    rebuild 2
    sha256 "196d095a5381b46c318b9bfba33e9c219b99c9d56d5059ca047acd957132c746" => :mojave
    sha256 "7fe432b58790def951944e5731cf4f1f8939d6b3e7c68390bed12106d16c52d0" => :high_sierra
    sha256 "86c84e08da72a016f132fe314f1fec7450e28fae18468d77669961831f6ee246" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "libusb"

  def install
    mkdir "libftdi-build" do
      system "cmake", "..", "-DPYTHON_BINDINGS=OFF", *std_cmake_args
      system "make", "install"
      (libexec/"bin").install "examples/find_all"
    end
  end

  test do
    system libexec/"bin/find_all"
  end
end
