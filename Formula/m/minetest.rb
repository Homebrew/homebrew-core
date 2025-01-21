class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/minetest/minetest/archive/refs/tags/5.10.0.tar.gz"
    sha256 "2a3161c04e7389608006f01280eda30507f8bacfa1d6b64c2af1b820a62d2677"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/refs/tags/5.8.0.tar.gz"
      sha256 "33a3bb43b08497a0bdb2f49f140a2829e582d5c16c0ad52be1595c803f706912"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0cc31303d48f9c83845989868c8bc78d5132096ad3de8938dd116068773be1f1"
    sha256 cellar: :any, arm64_sonoma:  "5cc8cd918fd8cf6887f5c9667ffb4ce576e709a0de9710a00804d7aa568c093d"
    sha256 cellar: :any, arm64_ventura: "703c818a629e6b467e7b6228e61cdb10edea4b35352dda30549ac6b6e97a3da4"
    sha256 cellar: :any, sonoma:        "e25ddc0f89ed707a2f5bf7611d496098340457c896e1dbca492f4f21edca6f76"
    sha256 cellar: :any, ventura:       "5f466fa264f0817a939d9165352d9a8eee12cd20928618717d270422925abc36"
    sha256               x86_64_linux:  "81295a377962e1212a9a1217e1284622a0d8411f7b3ec796b03493cd33607df3"
  end

  head do
    url "https://github.com/minetest/minetest.git", branch: "master"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "jsoncpp"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "luajit"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxi"
    depends_on "libxxf86vm"
    depends_on "mesa"
    depends_on "openal-soft"
    depends_on "xinput"
  end

  def install
    # Disable CMake fixup_bundle to prevent copying dylibs into app bundle
    inreplace "src/CMakeLists.txt", "fixup_bundle(", "# \\0"

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
    # Workaround for 'Could NOT find GettextLib (missing: ICONV_LIBRARY)'
    args << "-DICONV_LIBRARY=#{MacOS.sdk_path}/usr/lib/libiconv.tbd" if OS.mac? && MacOS.version >= :big_sur

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script prefix/"luanti.app/Contents/MacOS/luanti" if OS.mac?
  end

  test do
    # engine got changed from minetest to luanti with 5.10.0 release
    output = shell_output("#{bin}/luanti --version")
    assert_match "USE_CURL=1", output
    assert_match "USE_GETTEXT=1", output
    assert_match "USE_SOUND=1", output
  end
end
