class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.5.0/hatari-2.5.0.tar.bz2"
  sha256 "d76c22fc3de69fb1bb4af3e8ba500b7e40f5a2a45d07783f24cb7101e53c3457"
  license "GPL-2.0-or-later"
  head "https://git.tuxfamily.org/hatari/hatari.git", branch: "master"

  livecheck do
    url "https://download.tuxfamily.org/hatari/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fd62555b198d19de0d5afa2dcf6538030b015edbecbb67e7f71b6b0650b51e4e"
    sha256 cellar: :any,                 arm64_sonoma:   "c621abae9b430a09f6389df198a246bab810281201b4d7e87fbaac311db06d22"
    sha256 cellar: :any,                 arm64_ventura:  "cacb7a21109dc0377d2e24bcf8f183ea94c295fcae57688e9703de1e0ed6eceb"
    sha256 cellar: :any,                 arm64_monterey: "26032585bf8048b0987200009f9532d1a0281051644511269cc4918d94680b78"
    sha256 cellar: :any,                 sonoma:         "107fc887028fe359dc50681b60dca25b27bb498d333167874e021e4f8dc0f0b1"
    sha256 cellar: :any,                 ventura:        "0fc52a934a1d10afabf313998aadb3257cf1043d5232057c9b42714f9417b59a"
    sha256 cellar: :any,                 monterey:       "b3691b1718cea74b9fd1c859aaa7bae64732fb9d47ccc55ba8851628ee66e3c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3a872e656f3ca0cf1d3db8447e745c81b8ad652580f0481e571deded52351f3"
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
    url "https://downloads.sourceforge.net/project/emutos/emutos/1.3/emutos-1024k-1.3.zip"
    sha256 "076d451f15ddf7b64530c14431142b026569b1e5d6becc1af37aa008db81333f"
  end

  def install
    # Set .app bundle destination
    inreplace "src/CMakeLists.txt", "/Applications", prefix
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}", *std_cmake_args
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
