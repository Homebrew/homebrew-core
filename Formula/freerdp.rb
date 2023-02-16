class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.10.0.tar.gz"
  sha256 "88fa59f8e8338d5cb2490d159480564562a5624f3a3572c89fa3070b9626835c"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "3962f4d8fc6b873a085e429d2e1cd6ecb5e8f0528d12346b0d8b5297871a0e4e"
    sha256 arm64_monterey: "65385380b0748b5cc0ac2012478e592dd6aacdc698ef3c914bb02fab83dd06b4"
    sha256 arm64_big_sur:  "ab61d2a1ad23d2ac49a4f2719d3ee4664edc69b780191ef99305604e46e5c263"
    sha256 ventura:        "7e98964a57e71b78470727346c6af9587013d5594e9b1a10ecc947a28ec09541"
    sha256 monterey:       "775b85f8b0462129e9c6e958d4f913709a12523bd649ac6f0b81a3f6135f3a68"
    sha256 big_sur:        "68a63b87cf9deb4523748275d26c5c89cfb18d10c8d3a35e8f9eb3b229c18c0c"
    sha256 catalina:       "da77e3c22bef94303b804859965b7bad508717ab8639d351482d0b85c2e1af4a"
    sha256 x86_64_linux:   "2836bb43cb7266126991a78a30f8d2c0fbe37982a97216968c631e73e9167722"
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
