class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.5.1.tar.gz"
  sha256 "bb40028c90c156799bc26a8b5837754a62805ee371e988efc61903c7263843b1"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "36551f5b54e91f3c661241b3f30d5ecdabcc609ad974a5a20413ff8382e492f9"
    sha256 arm64_ventura:  "4e1fd912e4f90968ff3beba4bed06b8ed360075ed93d7a05ed2c210dbb650ce7"
    sha256 arm64_monterey: "3a8907647bc0eab8c95cb6edc6b788b82a6c61c4ed7b73bd05d946bbda2b8200"
    sha256 sonoma:         "07b36d5ed9531b8dff435029ce6dfb2766b0488a1a5e73956f8d2d8a513befb7"
    sha256 ventura:        "2e8f9e7bc9e08b364e106b02ae8f89f743b3a72e5a200b583a07d299324715b3"
    sha256 monterey:       "884baf5b6a3ae44b0bbc94f14e0760de1dd82f9db1b021e76a8dcf7154df7280"
    sha256 x86_64_linux:   "564eda660acc1c0e5302531cd67d95eefb8f2eb767774ba5c36e1c964da99ee1"
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
