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
    sha256 "94550492e4727f2fad9f6755c2dd5c157fde49eeb9b1d61ae02e0e766baeac61" => :high_sierra
    sha256 "5bc4fd32acb4a695a13e0ae31f67af7b1a09c131620690d1be68c1e4de88a582" => :sierra
    sha256 "a60cb7caad3e387805a55e4cf692f898564ac3e1d2b1ab9c40d41c1d82716954" => :el_capitan
  end

  head do
    url "https://github.com/minetest/minetest.git"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game.git", :branch => "master"
    end
  end

  depends_on :x11
  depends_on "cmake" => :build
  depends_on "irrlicht"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit" => :recommended
  depends_on "freetype" => :recommended
  depends_on "gettext" => :recommended
  depends_on "leveldb" => :optional
  depends_on "redis" => :optional

  def install
    (buildpath/"games/minetest_game").install resource("minetest_game")

    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]
    args << "-DCMAKE_BUILD_TYPE=Release" << "-DBUILD_CLIENT=1" << "-DBUILD_SERVER=0"
    args << "-DENABLE_REDIS=1" if build.with? "redis"
    args << "-DENABLE_LEVELDB=1" if build.with? "leveldb"
    args << "-DENABLE_FREETYPE=1" << "-DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'" if build.with? "freetype"
    args << "-DENABLE_GETTEXT=1" << "-DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}" if build.with? "gettext"

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
