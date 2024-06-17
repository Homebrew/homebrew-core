class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/minetest/minetest/archive/refs/tags/5.8.0.tar.gz"
    sha256 "610c85a24d77acdc3043a69d777bed9e6c00169406ca09df22ad490fe0d68c0c"

    resource "irrlichtmt" do
      url "https://github.com/minetest/irrlicht/archive/refs/tags/1.9.0mt13.tar.gz"
      sha256 "2fde8e27144988210b9c0ff1e202905834d9d25aaa63ce452763fd7171096adc"
    end

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/refs/tags/5.7.0.tar.gz"
      sha256 "0787b24cf7b340a8a2be873ca3744cec60c2683011f1d658350a031d1bd5976d"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "6d1e18e736c85005e57e7925e0064836df8fea870335b0836fbc34a8a2ef9ed1"
    sha256 cellar: :any, arm64_ventura:  "49c3f74ad32d15b9bdf5b9a50d0b030ceaee0765b807e6dd6ab88225d752de65"
    sha256 cellar: :any, arm64_monterey: "d72725938e822706c585254b1b0b7bffe46be99e9859ee31b37a1370fd157d7b"
    sha256 cellar: :any, sonoma:         "66e8431e983e91fe3337f52552f6296a825d7ef94b9fd92cc10ee21fe4097e63"
    sha256 cellar: :any, ventura:        "65085a5002468b37fcb1be9d8641ae701522be9a926c4832b386da9efa4f75f0"
    sha256 cellar: :any, monterey:       "7294300c1673038c329acda2ec74bea9f99752b98234dc5d238733d09a763875"
    sha256               x86_64_linux:   "ed27729be489033f9b22b8fbf5789c2848a6c1547289c2a16759a155ba12bf4d"
  end

  head do
    url "https://github.com/minetest/minetest.git", branch: "master"

    resource "irrlichtmt" do
      url "https://github.com/minetest/irrlicht.git", branch: "master"
    end

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "jsoncpp"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "luajit"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxxf86vm"
    depends_on "mesa"
    depends_on "openal-soft"
    depends_on "xinput"
  end

  def install
    # Disable CMake fixup_bundle to prevent copying dylibs into app bundle
    inreplace "src/CMakeLists.txt", "fixup_bundle(", "# \\0"

    # Remove bundled libraries to prevent fallback
    %w[lua gmp jsoncpp].each { |lib| (buildpath/"lib"/lib).rmtree }

    (buildpath/"games/minetest_game").install resource("minetest_game")
    (buildpath/"lib/irrlichtmt").install resource("irrlichtmt")

    args = %W[
      -DBUILD_CLIENT=1
      -DBUILD_SERVER=0
      -DENABLE_FREETYPE=1
      -DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'
      -DENABLE_GETTEXT=1
      -DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}
    ]
    # Workaround for 'Could NOT find GettextLib (missing: ICONV_LIBRARY)'
    args << "-DICONV_LIBRARY=#{MacOS.sdk_path}/usr/lib/libiconv.tbd" if OS.mac? && MacOS.version >= :big_sur

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script prefix/"minetest.app/Contents/MacOS/minetest" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/minetest --version")
    assert_match "USE_CURL=1", output
    assert_match "USE_GETTEXT=1", output
    assert_match "USE_SOUND=1", output
  end
end
