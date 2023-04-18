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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e07bbcf4adbb8d5d79cf789d689d4fedc1ddebe9863ed8339825e3e904565177"
    sha256 cellar: :any,                 arm64_monterey: "667e12e353a24d45995f336f687a23b44d6bfc6deca23f84e966e32e1e978571"
    sha256 cellar: :any,                 arm64_big_sur:  "b193a4d9e107c34a4a07a1aeef77786953e8d328ee085ca242342a6d107312fe"
    sha256 cellar: :any,                 ventura:        "4e343b2fc064affbd0d39b6f4d7460d71d9b18eaedf3c9b76b7ff6a0e7547bc0"
    sha256 cellar: :any,                 monterey:       "a3257660008936e85dbcc3227ddeb5014c39aa04e0a08e5f1ef5214abfd4c0e6"
    sha256 cellar: :any,                 big_sur:        "44257d9e4a6cf65ce62aec936a36dbcabee429d66341376f0749454e14c7d247"
    sha256 cellar: :any,                 catalina:       "95d8de415e6c641dc64dd92636b4aee0ff8c0d3a0b7fc60cab57406868b9fb7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f2c1ce5731913973b4d8caab05d82c893a85260ee47d95cea565526a4404c1d"
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
