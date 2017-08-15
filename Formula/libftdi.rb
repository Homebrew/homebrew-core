class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.4.tar.bz2"
  sha256 "ec36fb49080f834690c24008328a5ef42d3cf584ef4060f3a35aa4681cb31b74"

  bottle do
    cellar :any
    sha256 "7de0a718f6d40b3973d61e2f8ad40199ebcc6e683b186d12194d96eb783d319f" => :sierra
    sha256 "d7cfbf9ec3359f46a91da4a85a5cf4a0cbef310744bda6eb22f83433b49fca05" => :el_capitan
    sha256 "5e5bf957dc06881d204beb0eaf489aea3d23b36b51ccc15737a16deaf17bfed8" => :yosemite
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
