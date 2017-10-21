class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
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
    sha256 "557c9618fd6f9c16c13cf74ef76e3923e71334ba68c3100a60539d331edb802d" => :high_sierra
    sha256 "bd1bb5708000861f5406b4e95355f4474b372136e96db374076c29dc9464fa74" => :sierra
    sha256 "8ba27901ec54f9f141c3afb94406d22ec49f907f4e1c873375b5338703e1d3e2" => :el_capitan
    sha256 "a56489395aa0d13f322ced52167d8e46974bfd6e8302a0e6b0335df3082eed4e" => :yosemite
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

  def caveats; <<~EOS
      Put additional subgames and mods into "games" and "mods" folders under
      "~/Library/Application Support/minetest/", respectively (you may have
      to create those folders first).

      If you would like to start the Minetest server from a terminal, run
      "/Applications/minetest.app/Contents/MacOS/minetest --server".
    EOS
  end
end
