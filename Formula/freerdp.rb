class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.3.2.tar.gz"
  sha256 "a1f52f0d9569b418a555ffe4d15a3782712198be47308e9514d20ca5af41a1b1"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "1f42bf8b45b7e1a776b844e7b8b1c72bd83e635f8ffdf477789dc5d1f6aa0f3d"
    sha256 big_sur:       "8851fccd1933c8ec16d40938a72effaf07eade70759cf71665b8a5fdf44fad29"
    sha256 catalina:      "47096a60290cbcefa2a22268011bb1acb2ea8265973ba861542697856b55ba3f"
    sha256 mojave:        "f9c50b97f50cd29509e67d5d3c2ecc28e89612ffa7d1e3adaa15e6b6aa4556cd"
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
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
  depends_on "openssl@1.1"

  uses_from_macos "cups"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DWITH_X11=ON",
                         "-DBUILD_SHARED_LIBS=ON",
                         "-DWITH_JPEG=ON",
                         "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "make", "install"
  end

  test do
    on_linux do
      # failed to open display
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
