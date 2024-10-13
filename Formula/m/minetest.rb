class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1-or-later"
  revision 1

  stable do
    url "https://github.com/minetest/minetest/archive/refs/tags/5.9.1.tar.gz"
    sha256 "aa9a6ae57445b779f57dcba5a83b0704fabd24c5eca37c6c8611e885bdf09d7c"

    resource "irrlichtmt" do
      url "https://github.com/minetest/irrlicht/archive/refs/tags/1.9.0mt15.tar.gz"
      sha256 "12d24380a19be51cab29f54ae48fe08b327789da9c4d082ff815df60393d643f"
    end

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/refs/tags/5.8.0.tar.gz"
      sha256 "33a3bb43b08497a0bdb2f49f140a2829e582d5c16c0ad52be1595c803f706912"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "31b38964edc4fb6bad8830a28bf4db4f34befb6256b6924a68d9e0b74a4905e5"
    sha256 cellar: :any, arm64_sonoma:  "91eae1529bf5e5906dad91a3b40cd07ac2e7b2541d6146cc16b57cfdf6dd48de"
    sha256 cellar: :any, arm64_ventura: "c8beb0ff42ab5a252851e0cfdf4c47a4b82bef7224de6f23c23d685fbbc0bd67"
    sha256 cellar: :any, sonoma:        "94b69871386736f7d31e3626f2860e7014666fd1385152f8f9657c66c296e9e8"
    sha256 cellar: :any, ventura:       "cbf8d020363989b3bbf8de24546e14132ef4c2dc6a1afbfddadf55d4e3fd886f"
    sha256               x86_64_linux:  "1e7820a19108f1d61a5cc26d35ab8a65e3d12eb3b46aafd38ab052bf8bd2bd10"
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
