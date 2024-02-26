class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.3.0.tar.gz"
  sha256 "1667af42f8e84bd6e1478fe368c683f7bba6c736655483b0e778b25706bac9b3"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "a03b12a0cad828cbd31ba2d2c0cf8450004305449388e2978b101d9e16f20001"
    sha256 arm64_ventura:  "1b1298051d8af232b33a1409b4f5dbc7c347edc26b819f6ba0d85d79277b6c08"
    sha256 arm64_monterey: "a4f6847ffd88764a984707e35ea707bc050c14083c50411ed5cdbd3908036b5f"
    sha256 sonoma:         "4ef824c1a30e7dbb2a09dc652861d4b974725b448a9fed099171f32083ab3cf8"
    sha256 ventura:        "0328252b6770d76a58ed3053a5e0cb56180b188c613313b10057cdddfb19aa33"
    sha256 monterey:       "61b09f5756d8578ad02cbe701f4ac61587c09bd1fa1db6b22f6733e03c8aef29"
    sha256 x86_64_linux:   "e61bdc8209884db7c44c59c2b6c7101901a96c11329c60de95300a4e2b1f46ac"
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
