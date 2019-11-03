class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"

  stable do
    url "https://github.com/johnlockard/minetest/archive/5.1.0.tar.gz"
    sha256 "4180c94cc1fd8d2e502c223485ae60bd6c2c2fbe2164cc33b5fc83061fd3d364"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.1.0.tar.gz"
      sha256 "f165fac0081bf4797cf9094282cc25034b2347b3ea94e6bb8d9329c5ee63f41b"
    end
  end

  bottle do
    sha256 "21668f152c915c3376690da7c99f4efddaf8dfb138c550322b40789d4a50173b" => :mojave
    sha256 "4d05b170855c4215a39ba37e520f4f338de88e6bef724ac7201683272f4c7fdf" => :high_sierra
    sha256 "5122d65cef9f5f63b3511f627e25408cadf8f0158c119262413a9e8b8666ddc5" => :sierra
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
  depends_on "hiredis"
  depends_on "irrlicht"
  depends_on "jpeg"
  depends_on "leveldb"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit"
  depends_on "postgresql"
  depends_on "spatialindex"
  depends_on :x11

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

  test do
    #
    # --help and --version produce output directly.
    # --speedtests and --videomodes need user data directory in order to work.
    # --info and --trace need user data directory and will actually run the game.
    #
    # --run-unittests does not work for Homebrew.
    #
    # Debug File: all test information should wind up in here.
    #
    (testpath/"Library/Application Support/minetest/debug.txt").write("")
    system "#{prefix}/minetest.app/Contents/MacOS/minetest", "--speedtests"
  end
end
