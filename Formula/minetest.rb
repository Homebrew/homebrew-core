class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"

  stable do
    url "https://github.com/minetest/minetest/archive/5.1.0.tar.gz"
    sha256 "ca53975eecf6a39383040658f41d697c8d7f8d5fe9176460f564979c73b53906"

    # This patch is already merged in master and it should be removed when new version of mintest is released
    patch do
      url "https://github.com/minetest/minetest/pull/9064.patch"
      sha256 "251217d2c44f53c37419260bc329c5c09fe590342ff2c1c3a4c5cb7192cea550"
    end

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.1.0.tar.gz"
      sha256 "f165fac0081bf4797cf9094282cc25034b2347b3ea94e6bb8d9329c5ee63f41b"
    end
  end

  bottle do
    rebuild 1
    sha256 "4ec9b8e6e60c4b595dbac6c46de877b5388f99bc84f37237343f8230025f4d03" => :catalina
    sha256 "5bc5752b405790705eda2cd02896dbb9fe7c6a45201da68f6dfa1e22381708da" => :mojave
    sha256 "43d8c313c55a7fd721f174ec48aa07b28bd2c68be71dccf07b701a681169a510" => :high_sierra
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

  def install
    (buildpath/"games/minetest_game").install resource("minetest_game")

    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]
    args << "-DCMAKE_BUILD_TYPE=Release" << "-DBUILD_CLIENT=1" << "-DBUILD_SERVER=0"
    args << "-DENABLE_FREETYPE=1" << "-DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'"
    args << "-DENABLE_GETTEXT=1" << "-DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}"

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
