class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.5.0.tar.gz"
  sha256 "03323b383980ee91decbed88270bac061ffb17fd04e52576c70da7885601ecbe"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "63b48123ee967d7e4a837c7c56867695ec8bcfeca9d9f827bffc6209212b54ef"
    sha256 arm64_ventura:  "750f3d35c1bbda144abe5755c852afd6c83b5c6cd6d803b3fdf32bf7bb0cb8eb"
    sha256 arm64_monterey: "c57bfa34a66b5be6270aaccc38d7cbc61ef9f07f55f522416197d00dc9714693"
    sha256 sonoma:         "2fd356e7554730cbba3b3dd60b787e95ff8ec34ff80bc00442b9836fc82bb38b"
    sha256 ventura:        "aa315ea722548ae12c81e782977a5f2a769c9a7d10c256835c1a5221d59da87e"
    sha256 monterey:       "d14bd572a5d967491a7d8e036b031dc5cc9553de2cb419616ca3b0c7cc0678cd"
    sha256 x86_64_linux:   "449d1ebc69b61ca474941a280ef9fa6320bc47611509ed21c92d15db73dd25f2"
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
