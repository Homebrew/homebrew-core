class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.4.1/hatari-2.4.1.tar.bz2"
  sha256 "2a5da1932804167141de4bee6c1c5d8d53030260fe7fe7e31e5e71a4c00e0547"
  license "GPL-2.0-or-later"
  head "https://git.tuxfamily.org/hatari/hatari.git", branch: "master"

  livecheck do
    url "https://download.tuxfamily.org/hatari/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7dfc96424c9323adbf1427d8e2868a0ca4c911a096e0f72e717ada428f898ecd"
    sha256 cellar: :any,                 arm64_monterey: "6ccf45a0e90172a9dbbb1a6b09e079dad598c1671fe8224ff9e6320d397455b0"
    sha256 cellar: :any,                 arm64_big_sur:  "a55c6f1ea1139372de6b1f1b2214188b4fb30585a9deb14b3cc66920e2c78933"
    sha256 cellar: :any,                 monterey:       "616d67a6b4d33a440d721903d7e7528782befcfd685727ff221b8039953798b5"
    sha256 cellar: :any,                 big_sur:        "3204a6a4c8d2a852beaa269ab21d527b4b05668c80d373a1738d27f46bd49161"
    sha256 cellar: :any,                 catalina:       "5f68491c5dcd1a45e398cdf3124819d16d9adb4503c576c3085aecbea1ee4748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebf8ef00b8149b1e0e778d5fc7200f5258494a907ff4bcdf546370891a16aa27"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/1.2/emutos-1024k-1.2.zip"
    sha256 "65933ffcda6cba87ab013b5e799c3a0896b9a7cb2b477032f88f091ab8578b2a"
  end

  def install
    # Set .app bundle destination
    inreplace "src/CMakeLists.txt", "/Applications", prefix
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    if OS.mac?
      prefix.install "build/src/Hatari.app"
      bin.write_exec_script prefix/"Hatari.app/Contents/MacOS/hatari"
    else
      system "cmake", "--install", "build"
    end
    resource("emutos").stage do
      datadir = OS.mac? ? prefix/"Hatari.app/Contents/Resources" : pkgshare
      datadir.install "etos1024k.img" => "tos.img"
    end
  end

  test do
    assert_match "Hatari v#{version} -", shell_output("#{bin}/hatari -v", 1)
  end
end
