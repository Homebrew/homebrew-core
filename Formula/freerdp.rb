class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.8.1.tar.gz"
  sha256 "80afdf3fd4304bfc96d4792632660c5fb65ecf5c04c8872cb838a02f4b4cced3"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "c2c39da782f4df06eca40f1ef6cf8b398bcd623d0b9f071d6d5c3ac2ab7047d8"
    sha256 arm64_big_sur:  "5e065d087692150df9dbc8675ca19f165c03114766ea48fe77c5ce043e25d052"
    sha256 monterey:       "96ce94fde80de2a05572fbc9434c79945d977b494c8ea64f87fa12881628f340"
    sha256 big_sur:        "b408af2edaf7862ae59c9f47fbc03b3ec08a681bc8b7134dabe4b78da063995a"
    sha256 catalina:       "3f07f042a33e76153df32a8b57bb727843d3c8ff3ff90cb6715fc7ca65c78eb4"
    sha256 x86_64_linux:   "471e90a3aca9bb342a617d59cf1f933a7bb96335a912dce471aa2863246d87ef"
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git", branch: "master"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
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
  depends_on "openssl@3"

  uses_from_macos "cups"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DWITH_X11=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DWITH_JPEG=ON",
                    "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
