class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/releases/download/3.21.0/freerdp-3.21.0.tar.gz"
  sha256 "ec1409ce88020eeebc54e20cc0766cbe7d2e2f4bd382c7061c86f89231a9f44d"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "171f1315eb93136c0efc3c5f838cec6d8d7eca2b2407c00dd43a64e4d0e1d830"
    sha256 arm64_sequoia: "521380100dddc25d510d6a647f6f21f3eb5382a6073bf02a035348783264657f"
    sha256 arm64_sonoma:  "bb2cf8fd33767095132a7916d866a503eee224dc4a5f7dae3eaa6cdb6aa3243b"
    sha256 sonoma:        "3c351826348e05cb3554626240f1f8a4945c4f90f13b92ffc9276f693b16489c"
    sha256 arm64_linux:   "d63dbc8c585707a4e8007de0623f9b91a0815de11f8994e4fd0c8fd2e36c6589"
    sha256 x86_64_linux:  "7a762cf29838026a0c8d143c0b84571f7842f82db02f899275ef5fd6c9f587cd"
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git", branch: "master"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
  depends_on "sdl3"
  depends_on "sdl3_ttf"

  uses_from_macos "cups"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "glib"
    depends_on "icu4c@78"
    depends_on "krb5"
    depends_on "libfuse"
    depends_on "systemd"
    depends_on "wayland"
  end

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
    ]

    # Native macOS client and server implementations are unmaintained and use APIs that are obsolete on Sequoia.
    # Ref: https://github.com/FreeRDP/FreeRDP/issues/10558
    if OS.mac? && MacOS.version >= :sequoia
      # As a workaround, force X11 shadow server implementation. Can use -DWITH_SHADOW=OFF if it doesn't work
      inreplace "server/shadow/CMakeLists.txt", "add_subdirectory(Mac)", "add_subdirectory(X11)"

      args += ["-DWITH_CLIENT_MAC=OFF", "-DWITH_PLATFORM_SERVER=OFF"]
    end

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
