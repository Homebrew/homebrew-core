class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"

  stable do
    url "https://github.com/minetest/minetest/archive/0.4.17.1.tar.gz"
    sha256 "cd25d40c53f492325edabd2f6397250f40a61cb9fe4a1d4dd6eb030e0d1ceb59"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/0.4.17.tar.gz"
      sha256 "f0ab07cb47c1540b2016bf76a36e2eec28b0ea7827bf66fc5447e0c5e5d4495d"
    end
  end

  bottle do
    sha256 "4da5f8bebc6588cdf99b23cd2646e91425e15e2c625b8516728bd6970ed2e25b" => :mojave
    sha256 "7aa7a7e5a509efeb89b1ab0a897c250950ba117cc658c70c0892a3a4d4b882d5" => :high_sierra
    sha256 "7c76e9b683a0205f116403f6571c7e7c7cbd40f7bc16951ef0c350512cfc017e" => :sierra
    sha256 "ed87de74a782d339eee51f30e2d183eefd25a37e595df5f42157883afbeec133" => :el_capitan
  end

  head do
    url "https://github.com/minetest/minetest.git"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game.git", :branch => "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "irrlicht"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit"
  depends_on :x11

  def install
    (buildpath/"games/minetest_game").install resource("minetest_game")

    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]
    args << "-DCMAKE_BUILD_TYPE=Release" << "-DBUILD_CLIENT=1" << "-DBUILD_SERVER=0"
    args << "-DENABLE_FREETYPE=1" << "-DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'"
    args << "-DENABLE_GETTEXT=1" << "-DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}"

    # -ffast-math compiler flag is an issue on Mac
    # https://github.com/minetest/minetest/issues/4274
    inreplace "src/CMakeLists.txt", "-ffast-math", ""

    system "cmake", ".", *args
    system "make", "package"
    system "unzip", "minetest-*-osx.zip"
    prefix.install "minetest.app"
  end

  def caveats
    <<~EOS
      Put additional subgames and mods into "games" and "mods" folders under
      "~/Library/Application Support/minetest/", respectively (you may have
      to create those folders first).

      If you would like to start the Minetest server from a terminal, run
      "/Applications/minetest.app/Contents/MacOS/minetest --server".
    EOS
  end
end
