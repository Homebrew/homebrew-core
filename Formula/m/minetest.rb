class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/minetest/minetest/archive/refs/tags/5.9.0.tar.gz"
    sha256 "070bc292a0b7fc60d7ff0a14b364c8229c5cbe38296a80f948ea2c2591545a5c"

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
    sha256 cellar: :any, arm64_sonoma:   "e8e5604af5c4d57537c38475e16e42291522af7e084421d35552b318f0a59276"
    sha256 cellar: :any, arm64_ventura:  "61c45f1e9f61852595a7678bbb1e925f2310fd3b4e08c418d08ab66eb2ee235e"
    sha256 cellar: :any, arm64_monterey: "c59ecf29dde4fa974a2b448fac275454f28d6af72d362591e4891a7423e2de32"
    sha256 cellar: :any, sonoma:         "1a0502c221df753787423c5c088a3f202c6febb548bbe7a7558cd7b4fb64be19"
    sha256 cellar: :any, ventura:        "7c978b73a7db90f27149347a5caae88a52dde2b39cb8faa23e2519b82e2e1d56"
    sha256 cellar: :any, monterey:       "4971826e3e42072c097bfe2e5688bb351eef905f411982341a7c145a0de93786"
    sha256               x86_64_linux:   "0ade58d0ece3346f83d8519c180220db19f001210b4d5262a12ce4ca9a0f5e0e"
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
    depends_on "libxi"
    depends_on "libxxf86vm"
    depends_on "mesa"
    depends_on "openal-soft"
    depends_on "xinput"
  end

  def install
    # Disable CMake fixup_bundle to prevent copying dylibs into app bundle
    inreplace "src/CMakeLists.txt", "fixup_bundle(", "# \\0"

    # Remove bundled libraries to prevent fallback
    %w[lua gmp jsoncpp].each { |lib| rm_r(buildpath/"lib"/lib) }

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
