class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.4.tar.bz2"
  sha256 "ec36fb49080f834690c24008328a5ef42d3cf584ef4060f3a35aa4681cb31b74"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7cc50de6d35d5c7dd6d73a9ff075696dfe82ce57db9464c37b0a35dc0cf8707f" => :mojave
    sha256 "a28c4f481c8174edfb845492c4155511cac868082fd65cce625b55a82f3b54c0" => :high_sierra
    sha256 "ef603f79c7791bac035bf1afe21dcea4b6323372140a246f9aa52031b3631f6b" => :sierra
    sha256 "c023c826c533fd60e664a8f604f54017f84b356e625bbbafb8e5365e4319fa7a" => :el_capitan
    sha256 "7fc5addb888f58fbbd2a2e2e414ead4819a48b7fff4f6b0ebed274b499a38a40" => :yosemite
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
