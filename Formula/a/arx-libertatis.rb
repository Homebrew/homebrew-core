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
    rebuild 2
    sha256 arm64_golden_gate: "e9e3ba7512696c5734388ec8401086029cff865f417e251b89f3ac63f73b02c1"
    sha256 arm64_tahoe:       "75fff5f90379f2579818f529144c817b0a07de9f4e3937fc4046287271042b14"
    sha256 arm64_sequoia:     "0b1d9d0b4667e89fbefa27c6028933704c1b1c1d16cc806310b0ddfb6d508a0a"
    sha256 arm64_linux:       "6e499f620fbe0a637308dbd24489a16ee74ccb30173807deec8c1d8cfaecfdaa"
    sha256 x86_64_linux:      "635e03240035ca0966038f70efeee5aeeb0549db9db04cf656c8e3d7613447b5"
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
  depends_on "sdl2-compat"

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
    # Install PNG icons: generating the `.icns` needs `iconutil`, which the build sandbox's mach-lookup policy breaks
    args << "-DICON_TYPE=png"

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
