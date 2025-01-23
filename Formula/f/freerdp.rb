class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/releases/download/3.10.3/freerdp-3.10.3.tar.gz"
  sha256 "0bedda4ba1dcb225845522e24c595464aabce2c553a4c08b5c25a4977fbe1831"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "83096e9a4f7719c524458be02e3d39a3eda05826ce4be206e7506b25bca3234c"
    sha256 arm64_sonoma:  "f3b5f6ee74c2b0a62e7e14f4bcec3cc6b2597542e3ff3e599da92333cc13e29e"
    sha256 arm64_ventura: "9ec9c004c07690c48ca7fbb419bf96b16b7b18b8abb8f0ea8fe0f9cb86fd0f16"
    sha256 sonoma:        "ac014e327efdf6dbc1c69ee1978c0ba1be2b4c93e04ee196e5bf658946299085"
    sha256 ventura:       "41a58cd9acd6e5d2ff5e75e6f9788de04b731e9f234fe485c76357987f21e2e0"
    sha256 x86_64_linux:  "4cd97f76c4e70f823e61e3e030f71c129b609ed720a6bb6301cacadc98026950"
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
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  uses_from_macos "cups"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "icu4c@76"
    depends_on "krb5"
    depends_on "libfuse"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["sdl2_ttf"].opt_include}/SDL2"

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DWITH_X11=ON
      -DWITH_JPEG=ON
      -DWITH_MANPAGES=OFF
      -DWITH_WEBVIEW=OFF
      -DWITH_CLIENT_SDL=ON
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
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
