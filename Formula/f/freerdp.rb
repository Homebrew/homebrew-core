class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.7.0.tar.gz"
  sha256 "4c95055c2acd6916e4abc0b2168f201e0cec538bde4c39e25ed4b3bfdfefd047"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "d0ed18f61aa388a485d7795df52d7f5a107c64f23d4a7c1e273d1c0179452351"
    sha256 arm64_ventura:  "145c97e9ca7ba17e9c2dd02ef3b89191f6c900e483bc40a40d250d1fe8404e18"
    sha256 arm64_monterey: "3ace9f5aee797a526fd2da6f03335cfc5cd5c25f04cbfd224ae55f3d88f120e7"
    sha256 sonoma:         "b6c7afc56a6a427e98a161e1a24393799050aa1a5582e8a3d1a019a2b53978a0"
    sha256 ventura:        "f2bd25d4000ef79024d3bd1ae880963de399be1460add9d64f5a4080182d319f"
    sha256 monterey:       "b2a6b7fa6aa524c6de7b271be2feee98aa54b6b258283672ce845fb32312c136"
    sha256 x86_64_linux:   "34831086a2fee1933c892d3d9344967b28d6bffd439a457c3869b3f93ddac724"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "icu4c"
    depends_on "krb5"
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
