class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.8.0.tar.gz"
  sha256 "e313934a77a0bcca3af803455dd9ea1aa2f657c598e3397325aa48e6effd450d"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_sequoia: "93a2d51f524e50144df33eef37b6c28453e3fc6d621eb5ebdaa9fa0a97db7ec8"
    sha256 arm64_sonoma:  "087f88ef9f89502d167f38904921945de1d9148c2561ecfc5675d5b98d1eb653"
    sha256 arm64_ventura: "2c1bfddae3bd24c7200d0fc83dc75538d3b2385249aa4b02617246be2790c462"
    sha256 sonoma:        "3d73c5479a4f054a61d1bf435e2be79b1b7a6bbbed4e4ac92b244e2aab503cae"
    sha256 ventura:       "9724c26beb61d2ea7ae37064b5315b87162f9619903b1b5a6012a6891ba1916e"
    sha256 x86_64_linux:  "99e2380d3e06d44dd8428b2e255ad06ccfe8168971e28ae2aa3b66fb13e061f3"
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
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  uses_from_macos "cups"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "icu4c@75"
    depends_on "krb5"
    depends_on "libfuse"
    depends_on "systemd"
    depends_on "wayland"
  end

  # fix type conversion issue with `_Unwind_GetLanguageSpecificData`, upstream pr ref, https://github.com/FreeRDP/FreeRDP/pull/10542
  patch do
    url "https://github.com/FreeRDP/FreeRDP/commit/06d8164d5669c02759894d024f285e028c2023de.patch?full_index=1"
    sha256 "484407240002837cf9a32c6f1250c040710cdf1b78f8455565dca936c078d6c5"
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
