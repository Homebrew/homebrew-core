class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/2.11.1.tar.gz"
  sha256 "ee9d4b2767016c42d03f6fc6d7029ca6bb92502a82a40d7e3f0b37f2b977060b"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "526149bd0f997e3fca1b7ec50aca27cdeb1acf79057410947ce4e7debcbcad5d"
    sha256                               arm64_monterey: "d7dfc6216e4f6ab0b4dd488e2b57cb885857d039a5fb4978fdf8af285fcb988a"
    sha256                               arm64_big_sur:  "c889f7e2822bd0842dd46d99e87e0ef022f4c078f73f502e3aec31f085d84bf2"
    sha256                               ventura:        "d0720af49bf10247a974264ac01fa59c440b18740c2c6e9a33373f488b71efa1"
    sha256                               monterey:       "f3753fb8aa46696630ced7aecbd16300e6a6bbf403e86fd7ba0b91cf4ad524bc"
    sha256                               big_sur:        "18a66cdc37e2bae73889b62fe7d15442368edb5dc85f0acb88aaf74a87c27293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60cd79dc2e39fb070ad2e31fdd832a20850768c19141754174f251584acd3859"
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
