class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.4.0.tar.gz"
  sha256 "80eb7e09e2a106345d07f0985608c480341854b19b6f8fc653cb7043a9531e52"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_monterey: "187c40da430fbc9e2030bab48cbc96b92449ebec81932357f1801f7c7e513efa"
    sha256 arm64_big_sur:  "c7394ffbab31aca3baf2dde8ad790add11dba4b17f28b8dbd64d64ead1d7349b"
    sha256 monterey:       "8e8d221c837ba22a5a334386b6cd455af199e64c07bb67910077b6fbcdc817cb"
    sha256 big_sur:        "33b3d2b721d56ff90c2795ef0aa4d9258cbb2720ae214bf669b07fcdbbbdb765"
    sha256 catalina:       "4aa3704ddc6a134b9239084cf5a7ff6169f64bf69232049f1c0318220540b124"
    sha256 x86_64_linux:   "b196a3e07873e4a97ec4c93b0e8c2df48dbf90b9a86b8d5e17963181026f4862"
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
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
