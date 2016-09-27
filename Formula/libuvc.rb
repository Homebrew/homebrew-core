class Libuvc < Formula
  desc "Cross-platform library for USB video devices"
  homepage "https://github.com/ktossell/libuvc"
  url "https://github.com/ktossell/libuvc/archive/v0.0.5.tar.gz"
  sha256 "62652a4dd024e366f41042c281e5a3359a09f33760eb1af660f950ab9e70f1f7"

  head "https://github.com/ktossell/libuvc.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "87fe5bb38f766397c7dfd1a22529f781679dbf32f0bc2c1d2e1f5c53c1b124dd" => :sierra
    sha256 "6893748683e4eef0e0bd595acc9d7dce1e70d06778e264514ffd0fd26f3cf22d" => :el_capitan
    sha256 "5a20089a01f4c7f1d85bc91f6f2369ce5b1f1c4faf8c9beed2a764f80609ab41" => :yosemite
    sha256 "c2b007f5dad961d8767cc129d69ba352e0c8d6dff9746ee45697ceff6208ed8a" => :mavericks
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
