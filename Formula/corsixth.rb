class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/v0.65.1.tar.gz"
  sha256 "b8a1503371fa0c0f3d07d3b39a3de2769b8ed25923d0d931b7075bc88e3f508f"
  license "MIT"
  head "https://github.com/CorsixTH/CorsixTH.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "36611a5f4a62cc90fef41ca741dc799d166002964a52ee877103cf2101d17e08"
    sha256 arm64_big_sur:  "85159ab0c32c43fbe98e88181abd47c941acec95b5760646237d350f18ac403a"
    sha256 monterey:       "56e6fa94b1c1a026e48ffefe5a784a3718efedde66541de92176be1073b48f11"
    sha256 big_sur:        "7e0c673a852830521e8c5bf1edd8c0c55a73eb8e3fff9dd32e6939bbcf239620"
    sha256 catalina:       "4e32cf5b1460d07b4e354fec82d0a5267be4c03e1d3af92fc5d96046c44f8f8c"
    sha256 mojave:         "edb9df35dc84bddd751ecc716c37f7ef7f6f832a1b1613905214a8af6f507ea6"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  resource "lpeg" do
    url "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.2.tar.gz"
    mirror "https://sources.voidlinux.org/lua-lpeg-1.0.2/lpeg-1.0.2.tar.gz"
    sha256 "48d66576051b6c78388faad09b70493093264588fcd0f258ddaab1cdd4a15ffe"
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  def install
    # Make sure I point to the right version!
    lua = Formula["lua"]

    ENV["TARGET_BUILD_DIR"] = "."
    ENV["FULL_PRODUCT_NAME"] = "CorsixTH.app"

    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = luapath/"share/lua"/lua.version.major_minor/"?.lua"
    ENV["LUA_CPATH"] = luapath/"lib/lua"/lua.version.major_minor/"?.so"

    resources.each do |r|
      r.stage do
        system "luarocks", "build", r.name, "--tree=#{luapath}"
      end
    end

    system "cmake", ".", "-DLUA_INCLUDE_DIR=#{lua.opt_include}/lua",
                         "-DLUA_LIBRARY=#{lua.opt_lib}/liblua.dylib",
                         "-DLUA_PROGRAM_PATH=#{lua.opt_bin}/lua",
                         "-DCORSIX_TH_DATADIR=#{prefix}/CorsixTH.app/Contents/Resources/",
                         *std_cmake_args
    system "make"
    cp_r %w[CorsixTH/CorsixTH.lua CorsixTH/Lua CorsixTH/Levels CorsixTH/Campaigns CorsixTH/Graphics CorsixTH/Bitmap],
         "CorsixTH/CorsixTH.app/Contents/Resources/"
    prefix.install "CorsixTH/CorsixTH.app"

    lua_env = { LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"] }
    (bin/"CorsixTH").write_env_script(prefix/"CorsixTH.app/Contents/MacOS/CorsixTH", lua_env)
  end

  test do
    lua = Formula["lua"]

    app = prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
    assert_includes MachO::Tools.dylibs(app), "#{lua.opt_lib}/liblua.dylib"
  end
end
