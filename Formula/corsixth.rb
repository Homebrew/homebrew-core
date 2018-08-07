class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/v0.62.tar.gz"
  sha256 "b219270310255493c881a09bb4a5569f34a72cdaf3c3be920c1036a2450317ce"
  head "https://github.com/CorsixTH/CorsixTH.git"

  bottle do
    sha256 "1fc4ddc6726b87f9c390068aea8e50d9edb077d5f332ca0c873b3ca1237e7fcb" => :high_sierra
    sha256 "de102648ce1e10ca2de0dde2755ee995d68a677d91501db471d575de5e3318b7" => :sierra
    sha256 "574549efed705584e927187deb7fc44db7c40ff44b80b6239a5f175299ce56f4" => :el_capitan
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
    url "https://github.com/keplerproject/luafilesystem/archive/v1_7_0_2.tar.gz"
    sha256 "23b4883aeb4fb90b2d0f338659f33a631f9df7a7e67c54115775a77d4ac3cc59"
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

    system "cmake", ".", "-DLUA_INCLUDE_DIR=#{Formula["lua"].opt_include}/lua",
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
