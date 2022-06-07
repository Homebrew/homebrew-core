class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1-or-later"
  revision 1

  stable do
    url "https://github.com/minetest/minetest/archive/5.5.1.tar.gz"
    sha256 "dc0ae5188ef351db85c38b27f38f8549b133ed82aa46daea6deee148aa3454f4"

    # This patch fixes https://github.com/minetest/minetest/issues/12172
    # It has been merged upstream, and so should not be necessary for the next
    # minetest release (5.5.2)
    patch do
      url "https://github.com/minetest/minetest/commit/951604e29ff9d4b796003264574e06031c014a3f.patch?full_index=1"
      sha256 "46ca51997cadba9ec714de1988097ae37dec013def1cc4ae560d8de6b0f1d0bc"
    end

    resource "irrlichtmt" do
      url "https://github.com/minetest/irrlicht/archive/1.9.0mt4.tar.gz"
      sha256 "a0e2e5239ebca804adf54400ccaacaf228ec09223cfb2e1daddc9bf2694176e6"

      # This patch fixes https://github.com/minetest/minetest/issues/11541
      # It has been merged upstream, and so should not be necessary for the
      # next irrlicht release (1.9.0mt7)
      patch do
        url "https://github.com/minetest/irrlicht/commit/392df9bae3de8a71bf1d119a58dc2d9f1388751d.patch?full_index=1"
        sha256 "127b6ec571e6d6b2617bf9ece98b756da651dc1a9842fbf0e5a53f982fef1d6d"
      end
    end

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.5.0.tar.gz"
      sha256 "1e87252e26d6b1d3efe7720e3e097d489339dea4dd25980a828d5da212b01aaa"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "cdc7d369d90affea485e8bcc63f2967a92d21ad18bdff4e152edff651d0a2c49"
    sha256 cellar: :any, arm64_big_sur:  "9c24a32096f8928221026f96bf0577f88a8b0e92ac09c37fa74b3ad56656b6f4"
    sha256 cellar: :any, monterey:       "0edb70c8e765a07f5d76a1f0bef95c178450c70961aa15d1f978f9d8d00cc67d"
    sha256 cellar: :any, big_sur:        "71fe30043e317d083bdd51dacad821dcfbef76413b0069c01eb310a130cbd9db"
    sha256 cellar: :any, catalina:       "0d918c15c0df1d80e8f332789e251a87f84f3e2ba34e314780bf07a495d45580"
    sha256               x86_64_linux:   "cb4db8c60cc48312c53838dc636c2f5c8b401cab8bd108d3bc4e22e4d88f5e41"
  end

  head do
    url "https://github.com/minetest/minetest.git", branch: "master"

    resource "irrlichtmt" do
      url "https://github.com/minetest/irrlicht.git", branch: "master"
    end

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "freetype"
  depends_on "gmp"
  depends_on "jpeg"
  depends_on "jsoncpp"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "luajit-openresty"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxxf86vm"
    depends_on "mesa"
    depends_on "openal-soft"
  end

  def install
    inreplace "src/CMakeLists.txt" do |s|
      # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
      # On Apple ARM, the flags results in broken binaries and need to be removed.
      s.gsub! " -pagezero_size 10000 -image_base 100000000\"", "\""
      # Disable CMake fixup_bundle to prevent copying dylibs into app bundle
      s.gsub! "fixup_bundle(", "# \\0"
    end

    # Remove bundled libraries to prevent fallback
    %w[lua gmp jsoncpp].each { |lib| (buildpath/"lib"/lib).rmtree }

    (buildpath/"games/minetest_game").install resource("minetest_game")
    (buildpath/"lib/irrlichtmt").install resource("irrlichtmt")

    args = %W[
      -DBUILD_CLIENT=1
      -DBUILD_SERVER=0
      -DENABLE_FREETYPE=1
      -DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'
      -DENABLE_GETTEXT=1
      -DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}
    ]
    # Workaround for 'Could NOT find GettextLib (missing: ICONV_LIBRARY)'
    args << "-DICONV_LIBRARY=#{MacOS.sdk_path}/usr/lib/libiconv.tbd" if MacOS.version >= :big_sur

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Put additional subgames and mods into "games" and "mods" folders under
      "~/Library/Application Support/minetest/", respectively (you may have
      to create those folders first).

      To start minetest, from a terminal run
      "#{prefix}/minetest.app/Contents/MacOS/minetest".
    EOS
  end

  test do
    minetest = OS.mac? ? prefix/"minetest.app/Contents/MacOS/minetest" : bin/"minetest"
    output = shell_output("#{minetest} --version")
    assert_match "USE_CURL=1", output
    assert_match "USE_GETTEXT=1", output
    assert_match "USE_SOUND=1", output
  end
end
