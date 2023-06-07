class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8/easyrpg-player-0.8.tar.xz"
  sha256 "06e6d034348d1c52993d0be6b88fc3502a6c7718e366f691401539d5a2195c79"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "211cdf871015b27028a3e529c7a62372635f8c19d5576ebb93161f4f33bc256d"
    sha256 cellar: :any,                 arm64_monterey: "e3c8fe6e68be9bcc9e815c2d759f06e5c08cc6618db4671dfe4a00ecc0e5c936"
    sha256 cellar: :any,                 arm64_big_sur:  "be3604be94cc274440edc142fd5cbd28d7e30aa9edd1364db945e9d88d9929b1"
    sha256 cellar: :any,                 ventura:        "487d26e8b005fa4b49fa879cf5297ed81861c77a67f4dcd59819e5f832da9295"
    sha256 cellar: :any,                 monterey:       "9b1507d2f09cfcc05d08dcbc10e6d392dcc27022576c932f6770bfad46874c47"
    sha256 cellar: :any,                 big_sur:        "880a9a9fc46fb654bb8441cfe5483eb68efaeaa3a74ea01596f713e94da0acdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18942ef036e807ead1afa3071d4e2affa538948d6efcac46240a4c2ad2a6f6e9"
  end

  depends_on "cmake" => :build
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
      bin.write_exec_script "#{prefix}/EasyRPG Player.app/Contents/MacOS/EasyRPG Player"
      mv "#{bin}/EasyRPG Player", "#{bin}/easyrpg-player"
    end
  end

  test do
    assert_match(/EasyRPG Player #{version}/, shell_output("#{bin}/easyrpg-player -v"))
  end
end
