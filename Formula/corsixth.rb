class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  revision 2
  head "https://github.com/CorsixTH/CorsixTH.git"

  stable do
    url "https://github.com/CorsixTH/CorsixTH/archive/v0.60.tar.gz"
    sha256 "f5ff7839b6469f1da39804de1df0a86e57b45620c26f044a1700e43d8da19ce9"

    # Applies the upstream patch prioritising newer Luas over older ones.
    patch do
      url "https://github.com/CorsixTH/CorsixTH/commit/46420b76.patch?full_index=1"
      sha256 "024b4fad24d3427fe3050499eeaa2da95adc76f2a80df5ea3fe6ac363b545396"
    end
  end
  bottle do
    cellar :any
    sha256 "8ad4f5e7b203376341eed4b887f53fb7c6642d36dc18cdc16f10abb8ab9b777e" => :high_sierra
    sha256 "8f64c1ac8341a56c48c2ebceaa6ce24bf2321474217f6e9a3738c233108f6dfb" => :sierra
    sha256 "1216a1356bcff19b334a00bf97f983047b216ad30b3edb0fef2125c0749ec563" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :xcode => :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  resource "lpeg" do
    url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/lpeg-1.0.1.tar.gz"
    mirror "https://ftp.heanet.ie/mirrors/ftp.openbsd.org/distfiles/lpeg-1.0.1.tar.gz"
    sha256 "62d9f7a9ea3c1f215c77e0cadd8534c6ad9af0fb711c3f89188a8891c72f026b"
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v_1_6_3.tar.gz"
    sha256 "5525d2b8ec7774865629a6a29c2f94cb0f7e6787987bf54cd37e011bfb642068"
  end

  def install
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

    system "cmake", ".", "-DLUA_INCLUDE_DIR=#{Formula["lua"].opt_include}",
                         "-DLUA_LIBRARY=#{Formula["lua"].opt_lib}/liblua.dylib",
                         "-DLUA_PROGRAM_PATH=#{Formula["lua"].opt_bin}/lua",
                         *std_cmake_args
    system "make"
    prefix.install "CorsixTH/CorsixTH.app"

    env = { :LUA_PATH => ENV["LUA_PATH"], :LUA_CPATH => ENV["LUA_CPATH"] }
    (bin/"CorsixTH").write_env_script(prefix/"CorsixTH.app/Contents/MacOS/CorsixTH", env)
  end

  test do
    app = prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
    assert_includes MachO::Tools.dylibs(app),
                    "#{Formula["lua"].opt_lib}/liblua.5.3.dylib"
  end
end
