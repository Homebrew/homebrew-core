class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.3.2.tar.gz"
  sha256 "a1f52f0d9569b418a555ffe4d15a3782712198be47308e9514d20ca5af41a1b1"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "4ec216d0970f8275a53edfa8677ee49ab5634905f9610fe0329a9cbec21ae740"
    sha256 big_sur:       "13cb35f3a63d3ded009eea19ec6ee8fcfd875c5b9296eae6f5f2cb1093fce6ae"
    sha256 catalina:      "d8e6886ff2809e3192a39f38803378c398a64e3aa6f9f614e60447864aff05e3"
    sha256 mojave:        "0d9d9e131f4083303afb26ff40a0f90b1a502c4cdfeb49d69506952d5b50dbef"
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
    system "cmake", ".", *std_cmake_args,
                         "-DWITH_X11=ON",
                         "-DBUILD_SHARED_LIBS=ON",
                         "-DWITH_JPEG=ON",
                         "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "make", "install"
  end

  test do
    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
