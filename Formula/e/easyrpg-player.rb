class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8/easyrpg-player-0.8.tar.xz"
  sha256 "06e6d034348d1c52993d0be6b88fc3502a6c7718e366f691401539d5a2195c79"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "58952b86da9ef359cbb640042a4635c4b27013265c129fc6e672c10c9c4c4ae0"
    sha256 cellar: :any,                 arm64_ventura:  "01fe562f126d8571d3abb24297cd6a48577f10c0a047d8a9dc78ca961c12e9a1"
    sha256 cellar: :any,                 arm64_monterey: "48d57d7b229c35a45e122c4b4b82d603591b9f8c4677d145fc702c46ef4c4469"
    sha256 cellar: :any,                 sonoma:         "a71b166cc2277a799d20f5d320fc699cc001fb9b2088815d0eced97135d9eddd"
    sha256 cellar: :any,                 ventura:        "c0ac060a6efa3d7011d47dc04963e98df07bf7b685f1b56aeacd75f512a85774"
    sha256 cellar: :any,                 monterey:       "ec58c90d46532bfc65eff7f15e1f580c14fd87fee6ff513320a797b2e00a17f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebc52fa90ac66c9f16df457eac3cb563e3ab16d3740cf089b16b5fb64df5176f"
  end

  depends_on "cmake" => :build
  depends_on "expat"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c"
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
