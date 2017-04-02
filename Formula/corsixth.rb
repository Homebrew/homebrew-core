class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/v0.60.tar.gz"
  sha256 "f5ff7839b6469f1da39804de1df0a86e57b45620c26f044a1700e43d8da19ce9"
  head "https://github.com/CorsixTH/CorsixTH"

  bottle :disable, "LuaRocks requirements preclude bottling"

  depends_on "cmake" => :build
  depends_on :xcode => :build

  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  depends_on "lpeg" => :lua
  depends_on "luafilesystem" => :lua

  def install
    ENV["TARGET_BUILD_DIR"] = "."
    ENV["FULL_PRODUCT_NAME"] = "CorsixTH.app"
    system "cmake", ".", *std_cmake_args
    system "make"
    prefix.install "CorsixTH/CorsixTH.app"
    bin.write_exec_script "#{prefix}/CorsixTH.app/Contents/MacOS/CorsixTH"
  end
end
