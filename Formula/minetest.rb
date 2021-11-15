class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/minetest/minetest/archive/5.4.1.tar.gz"
    sha256 "de9e4410583c845c104b4be25f9d0b8743d8573c120149b8910ae2519f9ab14e"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.4.1.tar.gz"
      sha256 "b4bfa0755b88230cf4bdb6af6a0951dd1248f6cdf87fecc340e43ac12c80b0b2"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, monterey: "2c83905a5ce12b80226247f7eb8888ff4ef80c5050998161f510f61667af98d2"
    sha256 cellar: :any, big_sur:  "d391ffa3ef29483219449315ddf30ecd7d20e947bb5780081418dbb383ba938a"
    sha256               catalina: "8c773aabb5faa6617c09f69915a9e3caa49734d2f2117d05ce455597c8803695"
    sha256               mojave:   "e03ebb1d5ac5598e6c9273a89b98b30b95f9640bbb74d0b679e9b56621a06aca"
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
    args << "-DIRRLICHT_LIBRARY=#{Formula["irrlicht"].opt_frameworks}/IrrFramework.framework"

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
