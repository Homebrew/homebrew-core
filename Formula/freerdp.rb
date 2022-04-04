class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.6.1.tar.gz"
  sha256 "2ff86a839c1cf678a24d9bf435c83745aafbd5f0d19b637b733e306acede96e3"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "1a3fb66b98e886f55a43cdc828c11f8dcf2e32f89211b3df7f9e26e7a6b8a3ca"
    sha256 arm64_big_sur:  "a32bd32b4f6953631105f90d0c0cf0181192b5e3789392881083f5d0c9d66a08"
    sha256 monterey:       "9574179e198a9357c7d5840867dcb8a095ec6dde14e436ac29c70f9288b5015a"
    sha256 big_sur:        "283368a968f047011ff4b110edb37f79cc99e150c4342fc4a9a30ca4d60d326c"
    sha256 catalina:       "3dbe9fad2c00d0716251aab255552b84c57b9b571c94782ab8f03da5cbcaba40"
    sha256 x86_64_linux:   "f95d4e3dd43e5842e0e382e4d079d10b00ec73dda113940bb3c1fb56457bf23d"
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

  uses_from_macos "cups"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "systemd"
    depends_on "wayland"
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
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
