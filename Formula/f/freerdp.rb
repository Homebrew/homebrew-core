class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.4.0.tar.gz"
  sha256 "0fe77b2b838f32598a11c63ff4a1c0482d5bac0da7753ce6446039349ed96b00"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "712a72aa8fcd7d1202f93bfd2fce1fd2a70d692615110da24f319655935cec2f"
    sha256 arm64_ventura:  "79535139bf45740426adb59a3c6342c5548d633c7160913a77b2e3617e71a197"
    sha256 arm64_monterey: "1f54390117d0f395620b50b9ba7278953be83813c263d211ee08286f84a31e98"
    sha256 sonoma:         "1132855b7e0bcf5c176c38d3fabcae5476e601f5152c74511c18c02bfcf4e051"
    sha256 ventura:        "83338de572ec1ce03c28cbfafd6ebe67ad6a46ed963d7e9ebdedeb5ddddfeac6"
    sha256 monterey:       "5f8e6916ead9a12fb2d64e263b43e22e2207709345c8c182a4af87414c47df53"
    sha256 x86_64_linux:   "49fd8beaaaddbc5a9a63ecc0a020258f35c20ced35383c74b55314e1a67539ec"
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
