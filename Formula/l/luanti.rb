class Luanti < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.luanti.org"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/luanti-org/luanti/archive/refs/tags/5.12.0.tar.gz"
    sha256 "876867ac874492f20968f2c2eb4e403231e8e9f29e0e06efa512200bd5152355"

    resource "minetest_game" do
      url "https://github.com/luanti-org/minetest_game/archive/refs/tags/5.8.0.tar.gz"
      sha256 "33a3bb43b08497a0bdb2f49f140a2829e582d5c16c0ad52be1595c803f706912"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_linux:  "1fd142a559c013099e3cf03f96e1707409f1afde051fdf3dd691a29666f88264"
    sha256 x86_64_linux: "40e5c2756d0188f68d28f0418203c0b4b855b612303cd9a9e3b676bc067ebff6"
  end

  head do
    url "https://github.com/luanti-org/luanti.git", branch: "master"

    resource "minetest_game" do
      url "https://github.com/luanti-org/minetest_game.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "curl"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "jsoncpp"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libx11"
  depends_on "libxi"
  depends_on "libxxf86vm"
  depends_on :linux
  depends_on "luajit"
  depends_on "mesa"
  depends_on "ncurses"
  depends_on "openal-soft"
  depends_on "openssl@3"
  depends_on "sdl2"
  depends_on "sqlite"
  depends_on "xinput"
  depends_on "zlib"
  depends_on "zstd"

  def install
    # Remove bundled libraries to prevent fallback
    %w[lua gmp jsoncpp].each { |lib| rm_r(buildpath/"lib"/lib) }

    (buildpath/"games/minetest_game").install resource("minetest_game")

    args = %W[
      -DBUILD_CLIENT=1
      -DBUILD_SERVER=0
      -DENABLE_FREETYPE=1
      -DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'
      -DENABLE_GETTEXT=1
      -DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # engine got changed from minetest to luanti with 5.10.0 release
    output = shell_output("#{bin}/luanti --version")
    assert_match "USE_CURL=1", output
    assert_match "USE_GETTEXT=1", output
    assert_match "USE_SOUND=1", output
  end
end
