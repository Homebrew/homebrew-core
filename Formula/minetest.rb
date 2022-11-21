class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/minetest/minetest/archive/5.6.1.tar.gz"
    sha256 "1440603e19dca70e2691e86a74c822ee2c4a36fceee32b2d85ae74772149e9a3"

    resource "irrlichtmt" do
      url "https://github.com/minetest/irrlicht/archive/refs/tags/1.9.0mt8.tar.gz"
      sha256 "27594242da8c7cc1e5ef45922e1dfdd130c37d77719b5d927359eb47992051e0"
    end

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/refs/tags/5.6.1.tar.gz"
      sha256 "5dc857003d24bb489f126865fcd6bf0d9c0cb146ca4c1c733570699d15abd0e3"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "9e2ac2626be9b51ccc399acf6015e5fe5c1145ed39b3f87054c3aa3b8ed30c3c"
    sha256 cellar: :any, arm64_monterey: "44204d306faf6661f5cca1b9fa31ab19bb6dbe95843acdaad989029cfd3a0a11"
    sha256 cellar: :any, arm64_big_sur:  "7f9985b9a6437dd26301c72b8a0315309e7be24eef7a55378cf4d118d4471b45"
    sha256 cellar: :any, ventura:        "a9ba0a5ec4d8a0a2f3fded68567ed3987034991e55292b5dabb6937b5009554c"
    sha256 cellar: :any, monterey:       "2797dece689806632a0c7015e336a21155bb367555afa77c5b5890b61ae7110d"
    sha256 cellar: :any, big_sur:        "7a85c4ffc2d2a3460c6e4f2ce000cafe69b75530c24741bf77f16474e7ba0d96"
    sha256 cellar: :any, catalina:       "6778f81afea196d5c31727cee99a5498d012ba6c3dfb54f1b658cd4e1ddce543"
    sha256               x86_64_linux:   "fb6eb17f2af2e32de0c32588d93336cba026324ed12890c444411faf0b34c75f"
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
    depends_on "libxxf86vm"
    depends_on "mesa"
    depends_on "openal-soft"
    depends_on "xinput"
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

    bin.write_exec_script prefix/"minetest.app/Contents/MacOS/minetest" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/minetest --version")
    assert_match "USE_CURL=1", output
    assert_match "USE_GETTEXT=1", output
    assert_match "USE_SOUND=1", output
  end
end
