class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.7.0.tar.gz"
  sha256 "2350097b2dc865e54a3e858bce0b13a99711428d397ee51d60cf91ccb56c0415"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "cde0fdb6e408786ef74ae5d8222315ad4c145844e0cf257bd9f4d05d090e6ad6"
    sha256 arm64_big_sur:  "bcbbdf87d558f4db4cfa4e0019a3415204439fb9753ddede27ecfa98bb931382"
    sha256 monterey:       "a09cfd0938ba202fc66e6a8a367c5cf3d90745f0835267db9e333290dae6f290"
    sha256 big_sur:        "01f2093ad7930301f8c8105538dbb96094dad55ef288c364de32f789d1062687"
    sha256 catalina:       "9e21a6fc520a86ceb856a26b5832f1e55c78ab47e05595f62d38e6b1bbdf4b6b"
    sha256 x86_64_linux:   "5d1352efc56c8386f8b0d62f76b759fbf225dd7c10986e60148118095e8fbdd7"
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
