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
    sha256 cellar: :any, arm64_monterey: "d0c1097956b717f56544865134f04bb95028aa31b517749414d5370c9085977d"
    sha256 cellar: :any, arm64_big_sur:  "1c53d428c75053c524f66d441eb969185826e4d6b85b2f5315a219f9a805c7da"
    sha256 cellar: :any, monterey:       "323b69f263666c94f7f1d663da71a1fd43ab67c1f4ac24928c809cf2a17fd3ca"
    sha256 cellar: :any, big_sur:        "503c1267f5ec15cbea9f0d0b4b3f2f51e610c86f5ff4aafd97eb2ef492294b27"
    sha256 cellar: :any, catalina:       "71c7c50c24d662d3fbb6972c9d4b45e3adb35a0af91bc6ac9b20ba2a4a511e80"
    sha256               x86_64_linux:   "a65f247b5013345444d48341afbb9b410a42adcddb60663891c786768e81592c"
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
