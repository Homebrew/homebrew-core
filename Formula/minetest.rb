class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/minetest/minetest/archive/5.7.0.tar.gz"
    sha256 "0cd0fd48a97f76e337a2e1284599a054f8f92906a84a4ef2122ed321e1b75fa7"

    resource "irrlichtmt" do
      url "https://github.com/minetest/irrlicht/archive/refs/tags/1.9.0mt10.tar.gz"
      sha256 "6d00348d8ff513f6a7cee5c930908ef67428ff637e6a9e4d5688409bdb6d547d"
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
    sha256 cellar: :any, arm64_ventura:  "32246b9a68c1cc58d353a7e1e472f440f01712d7baf90f4724b3e75c3a9cd824"
    sha256 cellar: :any, arm64_monterey: "ff695caf85fac277c0e966adfb545c42647087dba289f1a587c5afba016d8c00"
    sha256 cellar: :any, arm64_big_sur:  "b8ca9d49163a9b20fcaeec0f179d5095e509a1ef8a9b7955214e2d3751a1c1ee"
    sha256 cellar: :any, ventura:        "11877f115e82a11a88775d106c433107d5b1f68d966a56963a16cd6e613693af"
    sha256 cellar: :any, monterey:       "14224d8d6ed9f0ae02b838423436b736b4eea64e7d44395ac00132d548e45c69"
    sha256 cellar: :any, big_sur:        "9faec3d05ba52ed4363013f0e39734c8dbc947d18e449e19a28174ae36c7ce6c"
    sha256               x86_64_linux:   "a57cbf410ed1abfa8e381715b327a2b154a6cec9d008ba880efc6b25591e5436"
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
    args << "-DICONV_LIBRARY=#{MacOS.sdk_path}/usr/lib/libiconv.tbd" if MacOS.version >= :big_sur

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
