class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.27.0.tar.gz"
  sha256 "57fb432341cca3f65dbd5cc458fcbf1ee44cede5e6d0a18390ff4b7aeac1c2ee"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "fe8df5b6564b01d38127145a5d7d62c155f99c4f3c5a385358d1c0bcad9ba00c"
    sha256 arm64_sequoia: "fe9a02643f26dd38dd75377a3d9810b845e6c114ce4299c18ed68065c2ed6554"
    sha256 arm64_sonoma:  "7b3d4086dda7ad8b3354ca997412df01088f1986c7449a8c8babf6692fa36468"
    sha256 sonoma:        "a3b4e930be17453bf6c4dc6ea6462e0343a5cfba018b8670f1871455ef0f1013"
    sha256 arm64_linux:   "62fa16735f29046ec5aaa56733de8da5c3428fc4a6b96d1b523e5eb0bf38bb42"
    sha256 x86_64_linux:  "4b97dc5e64c5e58e7c4f98675d4bfc208a0d580ab07f347f89a97843143564e2"
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git", branch: "master"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "ffmpeg"
  depends_on "libcbor"
  depends_on "libfido2"
  depends_on "jansson"
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
  depends_on "uriparser"

  uses_from_macos "cups"

  on_linux do
    depends_on "alsa-lib"
    depends_on "glib"
    depends_on "icu4c@78"
    depends_on "krb5"
    depends_on "libfuse"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "zlib-ng-compat"
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
