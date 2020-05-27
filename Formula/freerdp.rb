class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.1.1.tar.gz"
  sha256 "ce363a6578530cf508df802bb980a8dd49a874919bfa33b8c61d992ad0882bfb"

  bottle do
    sha256 "9c6d91706f66e424f89403204b4639cb8b0babd8dd221ff9d0267fbed8061250" => :catalina
    sha256 "22e617ec1d15745f4a697e5ecceacc260d9273dabcd9a3245e6e9acb26f1f15e" => :mojave
    sha256 "ce892ae166686e122a9f83e688d154330b2a3771bb13f6bb9dac7ca3bb01e954" => :high_sierra
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git"
    depends_on :xcode => :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "openssl@1.1"
  depends_on :x11

  def install
    system "cmake", ".", *std_cmake_args, "-DWITH_X11=ON", "-DBUILD_SHARED_LIBS=ON"
    system "make", "install"
  end

  test do
    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
