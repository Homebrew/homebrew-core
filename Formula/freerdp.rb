class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.8.1.tar.gz"
  sha256 "80afdf3fd4304bfc96d4792632660c5fb65ecf5c04c8872cb838a02f4b4cced3"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "8e3b0dddaf455f1c3a3b5367af70033655f71e9e2000d5846dcbe7a0a6d48bd8"
    sha256 arm64_big_sur:  "77cdff4426959c4b0e27d14547def8c74153bdee9a9de94dfce4431eda647859"
    sha256 monterey:       "e9160a333684357389f17c7b2201c00889e608aa8f4ad9a253bfce88f0a58051"
    sha256 big_sur:        "3a7000ba4e01548b680397d8da77cc11f4954437841dd99d6d9b089a54f9ce9f"
    sha256 catalina:       "05b66d971a652e073560cc3dfb97f069e830e116d1de6344f5bc17a1dabcee6f"
    sha256 x86_64_linux:   "594544e736334da9d07efd7595d833f96a9bdf4d93906a0c95e6a3b8cfa78fd9"
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
