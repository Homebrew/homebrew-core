class Libuvc < Formula
  desc "Cross-platform library for USB video devices"
  homepage "https://github.com/ktossell/libuvc"
  url "https://github.com/ktossell/libuvc/archive/v0.0.6.tar.gz"
  sha256 "42175a53c1c704365fdc782b44233925e40c9344fbb7f942181c1090f06e2873"

  head "https://github.com/ktossell/libuvc.git"

  bottle do
    cellar :any
    sha256 "0e2f8e177ecefcf0cd2a2c2be399d3e45fe18956642363b6f0e9b6632a7019da" => :sierra
    sha256 "2223e66660b7c600b71cb13cc9921c687bcc33e9e85fee7ab351c383e1533657" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "jpeg" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
