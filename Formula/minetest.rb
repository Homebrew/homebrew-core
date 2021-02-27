class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1"
  revision 1

  stable do
    url "https://github.com/minetest/minetest/archive/5.4.0.tar.gz"
    sha256 "6e9b299e156651be9bcf973a9232cff32215de31dfae5ea770a71d1757cab014"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.4.0.tar.gz"
      sha256 "520d2056085ec11e8806cf5a8f928537797d27a86704770bf408c113ea9881cb"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, big_sur:  "30d1427e3fafef0ede68549e111e9dbd9dcc78fb285c7c86803de2dab4c3c59d"
    sha256               catalina: "6b1f0ecc8f9565d6bf578af5c7dd567de2ae32bc522836dc88a6079ac5b65bcf"
    sha256               mojave:   "984fd05bd70577902fa1fb1d7c3cc0528ecfea99eb37fadb014ac24b62db25e4"
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
