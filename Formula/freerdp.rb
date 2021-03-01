class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.3.1.tar.gz"
  sha256 "3ad38d4bdd9cf97bd5425ea280961397129b28660743ab2f90eab88e8342459b"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "a6c080437545eeae6bd7d6e8516000bd58af1f059ac3fee9f35f89fe4c4ec443"
    sha256 big_sur:       "fc8f3dd6f8a80ed246cc27674372bfe519e927fbf54d01bc8b299c9f9dd625a7"
    sha256 catalina:      "db56d189b837043d17c001e43392c9db300e09abaa1c61d8b8128d85c26c9e6c"
    sha256 mojave:        "5112aee8f237bfa19a47f2d0a9cb084a24e7724f4a0841f7589141ba390a1fff"
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
