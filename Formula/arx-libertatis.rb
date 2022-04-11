class ArxLibertatis < Formula
  desc "Cross-platform, open source port of Arx Fatalis"
  homepage "https://arx-libertatis.org/"
  url "https://arx-libertatis.org/files/arx-libertatis-1.2.1/arx-libertatis-1.2.1.tar.xz"
  sha256 "aafd8831ee2d187d7647ad671a03aabd2df3b7248b0bac0b3ac36ffeb441aedf"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://arx-libertatis.org/files/"
    regex(%r{href=["']?arx-libertatis[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_monterey: "15ab54bf945b2d7916c4a69091d9284d9189b84292892bb62a0a5991c6f70bc3"
    sha256 arm64_big_sur:  "b320af2fcd3cac6c47927cb10371136efe9928e6130e764e557ec630bafbbd16"
    sha256 monterey:       "6c08a82f715868097a114724112d5c468a2f62fdef7ce3101693280a5395decd"
    sha256 big_sur:        "4d83d5a5f88214af1b7288fafc58d8514dd1abfbd1099c521560fcad539e34a9"
    sha256 catalina:       "6be181fec69da0fa1f513004361cc56543c6a9cdc8123730635714c4016ffd61"
    sha256 x86_64_linux:   "a3f69d5cecb4c1cfba16d5dbf7ca16f8e593b8b8007ea44bd1ee5c7b54c02bd5"
  end

  head do
    url "https://github.com/arx/ArxLibertatis.git"

    resource "arx-libertatis-data" do
      url "https://github.com/arx/ArxLibertatisData.git"
    end
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "innoextract"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openal-soft"
  end

  conflicts_with "rnv", because: "both install `arx` binaries"

  def install
    args = std_cmake_args

    # Install prebuilt icons to avoid inkscape and imagemagick deps
    if build.head?
      (buildpath/"arx-libertatis-data").install resource("arx-libertatis-data")
      args << "-DDATA_FILES=#{buildpath}/arx-libertatis-data"
    end

    mkdir "build" do
      system "cmake", "..", *args,
                            "-DBUILD_CRASHREPORTER=OFF",
                            "-DSTRICT_USE=ON",
                            "-DWITH_OPENGL=glew",
                            "-DWITH_SDL=2"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      This package only contains the Arx Libertatis binary, not the game data.
      To play Arx Fatalis you will need to obtain the game from GOG.com and
      install the game data with:

        arx-install-data /path/to/setup_arx_fatalis.exe
    EOS
  end

  test do
    system "#{bin}/arx", "-h"
  end
end
