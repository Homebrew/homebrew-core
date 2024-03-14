class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.4.0.tar.gz"
  sha256 "0fe77b2b838f32598a11c63ff4a1c0482d5bac0da7753ce6446039349ed96b00"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "7c0fdaa1536af56c725a01a5e57d7936fc5a36a2030ef2f41d7308c825f8c96e"
    sha256 arm64_ventura:  "ca0a311245b048ed39e4a58e4dff0e329ac316d54aa1238a3c6fabf162949810"
    sha256 arm64_monterey: "41821d68a1ff328dd5e593022dd9ab5cbd400935bf29b62e6d50caa668fac719"
    sha256 sonoma:         "1123e86fa2f79801ad686387f527ce667280566ba524811966d17c868371862e"
    sha256 ventura:        "8d7955e2d78081aa5027d6221e60f86ed6bd4d63ab4b29b8591640c729c14d8c"
    sha256 monterey:       "26e9b897025fdcab243b34946cb43f4151e3f3313f5fdda89ddf266425426ef8"
    sha256 x86_64_linux:   "4d872aa80cb69e0928b20408780e3a9b099bb97044a01d2c2dd324f65afb640e"
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git", branch: "master"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cjson"
  depends_on "ffmpeg"
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
  depends_on "pkcs11-helper"

  uses_from_macos "cups"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "libfuse"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    args = %W[
      -DWITH_X11=ON
      -DBUILD_SHARED_LIBS=ON
      -DWITH_JPEG=ON
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DWITH_MANPAGES=OFF
      -DWITH_WEBVIEW=OFF
      -DWITH_CLIENT_SDL=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    extra = ""
    on_macos do
      extra = <<~EOS

        XQuartz provides an XServer for macOS. The XQuartz can be installed
        as a package from www.xquartz.org or as a Homebrew cask:
          brew install --cask xquartz
      EOS
    end

    <<~EOS
      xfreerdp is an X11 application that requires an XServer be installed
      and running. Lack of a running XServer will cause a "$DISPLAY" error.
      #{extra}
    EOS
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
