class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.4.0.tar.gz"
  sha256 "80eb7e09e2a106345d07f0985608c480341854b19b6f8fc653cb7043a9531e52"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "13930739489389e5ecad0f8afa3d05bf41698a01b880c561f0ad05e099a9a8f3"
    sha256 big_sur:       "0350c39447e947f7d860d12d4658eb6481f1afa83316a84249cba336e1b79776"
    sha256 catalina:      "02424460eacaf34e564f922c26e096c74a145fde68067cfd2f3426c811dc0b11"
    sha256 mojave:        "8c029ee46cd1ea1662c5969858aadb78f2311f4cfe4397d5119ac94aa039a650"
    sha256 x86_64_linux:  "a5c914c81394cb1c941d78ebfb2813ba94494af167d5bcb3d4e71cb3bfec10a1"
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
