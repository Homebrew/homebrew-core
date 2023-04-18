class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  # TODO: Check if this can use unversioned ffmpeg at version bump.
  url "https://github.com/FreeRDP/FreeRDP/archive/2.10.0.tar.gz"
  sha256 "88fa59f8e8338d5cb2490d159480564562a5624f3a3572c89fa3070b9626835c"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256                               arm64_ventura:  "f1db8f50c5fe4ff993c6a6b72d8e6873fe8aff3e9edb6aeab8132a5b90c57604"
    sha256                               arm64_monterey: "ac9fe6b9270f32b24308a11a1b44e0cc7bdda8fda9e39344f7cb31561fd26e27"
    sha256                               arm64_big_sur:  "16e00d3b71957ce3a40d297543ae23cd4eca38d8c39c4e741e9b72da2dd3709c"
    sha256                               ventura:        "555a15ff9e75aa6fd486f4ac9980df93b1344382cf6e5b5cc4c5a70024480083"
    sha256                               monterey:       "587de54a0cf9a89fe1fc0f153c3fdcf3d0c944917bba62f716602e5b6eb46a4a"
    sha256                               big_sur:        "2bb947c3e0002c1035dc98dff3a78879107d851837e047f0bf5f31fa21e15203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f748f1eab362120a49bb3a6031b614536278819ef09988d3e5b0c5fff7b4e58"
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
    depends_on "ffmpeg@4"
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
