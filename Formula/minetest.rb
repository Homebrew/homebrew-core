class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1"

  stable do
    url "https://github.com/minetest/minetest/archive/5.3.0.tar.gz"
    sha256 "65dc2049f24c93fa544500f310a61e289c1b8fa47bf60877b746a2c27a7238d6"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.3.0.tar.gz"
      sha256 "06c6c1d4b97af211dd0fa518a3e68a205f594e9816a4b2477e48d4d21d278e2d"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 "1a0e503d7c53c7a62650c0f5b0f76ba3e6b51d10ac07d9a17b0d8c56a2900234" => :big_sur
    sha256 "92e0b98ccb73b2ab82272dd9a165007e84dcd493453cb3701c6881b44758654d" => :catalina
    sha256 "c42e63842c20316be1582bca49e00da8302e11409a388cd6f537148d2740d400" => :mojave
  end

  head do
    url "https://github.com/minetest/minetest.git"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game.git", branch: "master"
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

    args = std_cmake_args
    args << "-DBUILD_CLIENT=1" << "-DBUILD_SERVER=0"
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
      "#{prefix}/minetest.app/Contents/MacOS/minetest --server".
    EOS
  end

  test do
    system "#{prefix}/minetest.app/Contents/MacOS/minetest", "--version"
  end
end
