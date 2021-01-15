class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/v0.64.tar.gz"
  sha256 "12389a95de0031baec1a3fc77208d44228177f49564f1c79ae763ab4aeeafa98"
  license "MIT"
  revision 1
  head "https://github.com/CorsixTH/CorsixTH.git"

  bottle do
    sha256 "9852913d485e6fce557001d16f78dac562b205c44810d93b133b539c02ed0436" => :big_sur
    sha256 "fb20eddb21a89396791d6ab3dfdf13c0bde91c44ba0a6f068b59194b361c4690" => :arm64_big_sur
    sha256 "bad3d139e3cac3c277a9bea632819fe27b90abfd7d5305813f839d78f5854ca6" => :catalina
    sha256 "a68aaf41d6feda1bbed25fa4fbb7ff73dc4b5049e23c13fb9377b22cb23c17a4" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "freetype"

  # This PR implements a limited form of lua 5.4 support:
  # https://github.com/CorsixTH/CorsixTH/pull/1686
  # It breaks some features.  Maintainer does not appear to have intentions of
  # supporting lua 5.4.
  depends_on "lua@5.3"

  depends_on "sdl2"
  depends_on "sdl2_mixer"

  resource "lpeg" do
    url "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.2.tar.gz"
    mirror "https://sources.voidlinux.org/lua-lpeg-1.0.2/lpeg-1.0.2.tar.gz"
    sha256 "48d66576051b6c78388faad09b70493093264588fcd0f258ddaab1cdd4a15ffe"
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_7_0_2.tar.gz"
    sha256 "23b4883aeb4fb90b2d0f338659f33a631f9df7a7e67c54115775a77d4ac3cc59"
  end

  def install
    # Make sure I point to the right version!
    lua = Formula["lua@5.3"]

    ENV["TARGET_BUILD_DIR"] = "."
    ENV["FULL_PRODUCT_NAME"] = "CorsixTH.app"

    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "#{luapath}/share/lua/5.3/?.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.3/?.so"

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

    env = { LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"] }
    (bin/"CorsixTH").write_env_script(prefix/"CorsixTH.app/Contents/MacOS/CorsixTH", env)
  end

  test do
    # Make sure I point to the right version!
    lua = Formula["lua@5.3"]

    app = prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
    assert_includes MachO::Tools.dylibs(app),
                    "#{lua.opt_lib}/liblua.#{lua.version.major_minor}.dylib"
  end
end
