class ArxLibertatis < Formula
  desc "Cross-platform, open source port of Arx Fatalis"
  homepage "https://arx-libertatis.org/"
  url "https://arx-libertatis.org/files/arx-libertatis-1.2.1/arx-libertatis-1.2.1.tar.xz"
  sha256 "aafd8831ee2d187d7647ad671a03aabd2df3b7248b0bac0b3ac36ffeb441aedf"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://arx-libertatis.org/files/"
    regex(%r{href=["']?arx-libertatis[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d56d81aaee01fa139752c15b0fbc8332ed44443c94a9826771be22cc2544a77f"
    sha256 arm64_sequoia: "14a65b2ec634da2454970e12de3b588f0826e121c04da2569857dd753cb0a797"
    sha256 arm64_sonoma:  "96be79e0ee8f79cfa402f327be3ee1faa6f509e609d6d8c48c368b5b83112e9b"
    sha256 sonoma:        "38f33f4125e39dc04470caab71dac5869f57044d4ed829433cb038ef1b4d531f"
    sha256 arm64_linux:   "9c882ed838c94379ea0f0425dde3f5c144ab4024582524e44442924daa06d5e9"
    sha256 x86_64_linux:  "819d7a57ea0a2f2bf4a0d1b8af9c62c07db85f75ad23166be635140235f0f70f"
  end

  head do
    url "https://github.com/arx/ArxLibertatis.git", branch: "master"

    resource "arx-libertatis-data" do
      url "https://github.com/arx/ArxLibertatisData.git", branch: "master"
    end
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "innoextract"
  depends_on "sdl2"

  on_linux do
    depends_on "mesa"
    depends_on "openal-soft"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "rnv", because: "both install `arx` binaries"

  def install
    args = %w[
      -DBUILD_CRASHREPORTER=OFF
      -DSTRICT_USE=ON
      -DWITH_OPENGL=glew
      -DWITH_SDL=2
    ]

    # Install prebuilt icons to avoid inkscape and imagemagick deps
    if build.head?
      (buildpath/"arx-libertatis-data").install resource("arx-libertatis-data")
      args << "-DDATA_FILES=#{buildpath}/arx-libertatis-data"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    output = shell_output("#{bin}/arx --list-dirs")
    assert_match "User directories (select first existing)", output
  end
end
