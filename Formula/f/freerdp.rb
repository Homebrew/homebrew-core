class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.33.1.tar.gz"
  sha256 "6b6da1e7217f924b033da6896e70eb4c4a447c3900d03c0d10179062f0a7d495"
  license "Apache-2.0"
  revision 1
  head "https://github.com/FreeRDP/FreeRDP.git", branch: "master"

  bottle do
    manifest_sha256 "b2cfef81646c62c44e00b35511bc7e1ad279808668079665da00981c42f9de4e"
    sha256 arm64_golden_gate: "aedf9e8f5b450c144cf659f54a782b22fb18b3dbeada1254613dbf9abc6b818e"
    sha256 arm64_tahoe:       "e9e59d84a4dd8cbf5f158928f30dce96d3d1a00ebff89addf848430826420280"
    sha256 arm64_sequoia:     "e666a11d59c589ad6c1af400dabd04235944285de83b3794446ede2536293b05"
    sha256 arm64_linux:       "118a38e82617cc65358ec65ec49ba90739f9bd5690a1e2afb8272828bc8d123b"
    sha256 x86_64_linux:      "92ce68f0fe49d16aaa3d7ec8f52b5f0ac40eb067677ecc7a94cd63fbd4e8ff84"
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
