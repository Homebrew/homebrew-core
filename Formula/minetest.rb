class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "http://www.minetest.net/"
  revision 1

  stable do
    url "https://github.com/minetest/minetest/archive/0.4.16.tar.gz"
    sha256 "0ef3793de9f569746ea78af7a66fe96ef65400019e5e64a04a5c3fa26a707655"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/0.4.16.tar.gz"
      sha256 "ea914555949b4faccda5e13143cb021d2f9a5fa19abd1f5e4b7b65004cbd2b5a"
    end
  end

  bottle do
    sha256 "2df86e7470115d04306e4745fa91db40a26b31db23385bd6d11cbcc366a2be24" => :sierra
    sha256 "eb2169122bf929ad89140b5b6f83f11bd38379353a2a379778ae53a5a3fc5dd4" => :el_capitan
    sha256 "8fe1c02e6f63e177ed8bf03e7da54fae6502029f631b7297e4895a5f5623730b" => :yosemite
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

  def caveats; <<-EOS.undent
      Put additional subgames and mods into "games" and "mods" folders under
      "~/Library/Application Support/minetest/", respectively (you may have
      to create those folders first).

      If you would like to start the Minetest server from a terminal, run
      "/Applications/minetest.app/Contents/MacOS/minetest --server".
    EOS
  end
end
