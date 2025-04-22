class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8.1/easyrpg-player-0.8.1.tar.xz"
  sha256 "51249fbc8da4e3ac2e8371b0d6f9f32ff260096f5478b3b95020e27b031dbd0d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://easyrpg.org/player/downloads/"
    regex(/href=.*?easyrpg-player[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "29b59ec328ebcb9bdaf09f645ec253dc455aadbe85ac151a615c1c933eb405f0"
    sha256 cellar: :any,                 arm64_sonoma:  "221de8ecdaee1f3b57abc2ad397173452de46d56ef6f31a755cc3c9c27c06b9c"
    sha256 cellar: :any,                 arm64_ventura: "6ffd6cdda3ee15171eb3dd10b5a4c5db985db99aa8d3b9d7657be393191e04bf"
    sha256 cellar: :any,                 sonoma:        "3e7e8cdde63642d4f0868ddcda54828b4bbe156e43a13ca369cd0d929512e713"
    sha256 cellar: :any,                 ventura:       "9316377552b03c9261c8333248adfbecee36b78041fe1cc0f38601d73c24461e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91fa3ccab4d41d231137740cb587782357d5ad146d247a6a42b578bb77933f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a94c58e93a48d1450056d002a5759e7db40b694ae5a6f2f0ada4e09f5f74a4"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "speexdsp"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
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
