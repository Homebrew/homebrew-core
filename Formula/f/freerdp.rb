class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.33.1.tar.gz"
  sha256 "6b6da1e7217f924b033da6896e70eb4c4a447c3900d03c0d10179062f0a7d495"
  license "Apache-2.0"
  head "https://github.com/FreeRDP/FreeRDP.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "969de1d1c69ec8f773b4bfa8cf7c3726c6f48f5dac57fdd0dc5b09608caabfe3"
    sha256 arm64_tahoe:       "ff58b96b9260a785b1e998d6487b187b2ea169a0570967b252c1bbbdd2c82be9"
    sha256 arm64_sequoia:     "c03b0f3d110be155aa74e66b9fd0c9eea7cab8ca7e838622bca401cad67ff442"
    sha256 arm64_linux:       "9b8991fb39715ca07bbfe0f7fcfda442e581ffcbb8aeedaf1853e44770ac4790"
    sha256 x86_64_linux:      "57a8a9865b0217e5f67951ae47925f742a43833de54477b1684ef823c0ac98a7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "jpeg-turbo"
  depends_on "libcbor"
  depends_on "libfido2"
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
  depends_on "openssl@4"
  depends_on "sdl3"
  depends_on "sdl3_ttf"
  depends_on "uriparser"

  uses_from_macos "cups"

  on_linux do
    depends_on "alsa-lib"
    depends_on "glib"
    depends_on "icu4c@79"
    depends_on "krb5"
    depends_on "libfuse"
    depends_on "pulseaudio"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DWITH_X11=ON
      -DWITH_JPEG=ON
      -DWITH_MANPAGES=OFF
      -DWITH_WEBVIEW=OFF
      -DWITH_CLIENT_SDL=ON
      -DWITH_CLIENT_SDL2=OFF
      -DWITH_CLIENT_SDL3=ON
      -DCHANNEL_RDPEWA=ON
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
    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
