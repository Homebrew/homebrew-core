class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://www.hatari-emu.org/"
  url "https://framagit.org/hatari/releases/-/raw/main/v2.6/hatari-2.6.0.tar.bz2"
  sha256 "bd98e4c1b218669087f579ab9491178f93e5409bb895b487c899d1f911e9603a"
  license "GPL-2.0-or-later"
  head "https://framagit.org/hatari/hatari.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "53dc32f79ae689f106dd520edfb9a1096f2869ad5ecd94b604c7a5fff49d73e5"
    sha256 cellar: :any,                 arm64_sonoma:  "b98449909d4e40320d346e224bdc11b55b85fb809f60311ad7ab0369e6d3a8b1"
    sha256 cellar: :any,                 arm64_ventura: "48724c5659b9125142ca27f59ee8de9d622cfc5b1595a0c11c76791dfb204859"
    sha256 cellar: :any,                 sonoma:        "8a755dc9f4b831cae3643f8f90049ffaff37e4aa01f79f511180061dfdafcc48"
    sha256 cellar: :any,                 ventura:       "497de1a56b32c1b9025561640690eeb1dc9f3e9172bcc64226e2205e8a8eec47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6577252c5abd6e8832bd7985e2909a5617a9d78211815cabbae6fa16cb2cc83b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a13089841344519383fd7010393ebb0cb639eae84771c82f908e973776630d1"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "readline"
  end

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/1.4/emutos-1024k-1.4.zip"
    sha256 "dc9fbef6455a24ee8955cccd565588c718ba675fd54bc5a749003ac4bbd7f7e1"

    livecheck do
      url "https://sourceforge.net/projects/emutos/rss?path=/emutos"
      regex(%r{/emutos[._-]1024k[._-](\d+(?:\.\d+)+)\.z}i)
    end
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
