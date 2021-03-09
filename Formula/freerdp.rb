class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.3.1.tar.gz"
  sha256 "3ad38d4bdd9cf97bd5425ea280961397129b28660743ab2f90eab88e8342459b"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "02750821918300bf19eaa74d2c33e682e039c56b031bd457ea34c44aa5d1c775"
    sha256 big_sur:       "6749c4947104700623d490bef618940b61761092dc19c36114f7433d87f89401"
    sha256 catalina:      "2030c40a5c115c104eca4f0b0486b5a6d4df9db6a58766fab6394ba5c40dc048"
    sha256 mojave:        "51646ebf8995145dce582aa12915f33393acef1ded829dee409f59dcb62cfeb1"
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libusb"
  depends_on "libx11"
  depends_on "libxcursor"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxi"
  depends_on "libxinerama"
  depends_on "libxrandr"
  depends_on "libxrender"
  depends_on "libxv"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DWITH_X11=ON", "-DBUILD_SHARED_LIBS=ON", "-DWITH_JPEG=ON"
    system "make", "install"
  end

  test do
    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
