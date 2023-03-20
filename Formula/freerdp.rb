class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.10.0.tar.gz"
  sha256 "88fa59f8e8338d5cb2490d159480564562a5624f3a3572c89fa3070b9626835c"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "bfdb1fec28d4395805d5cec843c88f0d4164d8f530145b1263cda54764e54cb5"
    sha256                               arm64_monterey: "6866ca2a058eafd2c034575e5a9974f6e44ecc2ed963740b938c7c6ddfac3a65"
    sha256                               arm64_big_sur:  "ab11ca21e7cb15ac1982ab192be5069a3a6a9e2760140df051f1e21f66f8c8af"
    sha256                               ventura:        "01de631c39bd0de0140aa04a3b4a3c4e49a229052ec45b3981b79e834c8e8eb7"
    sha256                               monterey:       "37695834d8e2ef56aafc50b2d75672c93f5a0487f0d69e93385170bc90554172"
    sha256                               big_sur:        "3cc55b92aeb0738b86b10a84b3cf5ddc35ff96ed046b100fbe816ddc8480be96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56007a1eb1dd9349c7f6fa5eadad2df21ea1dd82906a59dc49582130f743440c"
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git", branch: "master"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

  uses_from_macos "cups"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DWITH_X11=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DWITH_JPEG=ON",
                    "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
