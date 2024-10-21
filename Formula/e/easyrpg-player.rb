class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8/easyrpg-player-0.8.tar.xz"
  sha256 "06e6d034348d1c52993d0be6b88fc3502a6c7718e366f691401539d5a2195c79"
  license "GPL-3.0-or-later"
  revision 5

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed3647547b6f153cccfe3771832a67936708da6baf03e8d440f3237a75f84356"
    sha256 cellar: :any,                 arm64_sonoma:  "5b27a034830a4050954923f9b206bb7246173db519e0b845191bb41429005a5e"
    sha256 cellar: :any,                 arm64_ventura: "c163e38ecf71c3874abea6103d9bf1c9b860c35b7e0c07d6f52bcd6295b805c9"
    sha256 cellar: :any,                 sonoma:        "04a3f8684b52013b2afd12721cf387120682a6a3a44c7022663fc56b968e3872"
    sha256 cellar: :any,                 ventura:       "d76943f69db08caad588017b69493856909aee291ecc03137ea753f3e98ff7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a22f0febddd000ad159bad7a0422ed6bfb5f0e98a9e28d6d3d45c5a16857f12"
  end

  depends_on "cmake" => :build
  depends_on "expat"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@75"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "speexdsp"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
  end

  fails_with gcc: "5"

  # Add support for fmt 10
  patch do
    url "https://github.com/EasyRPG/Player/commit/a4672d2e30db4e4918c8f3580236faed3c9d04c1.patch?full_index=1"
    sha256 "026df27331e441116d2b678992d729f9aec3c30b52ffde98089527a5a25c79eb"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install "build/EasyRPG Player.app"
      bin.write_exec_script prefix/"EasyRPG Player.app/Contents/MacOS/EasyRPG Player"
      mv bin/"EasyRPG Player", bin/"easyrpg-player"
    end
  end

  test do
    assert_match "EasyRPG Player #{version}", shell_output("#{bin}/easyrpg-player -v")
  end
end
