class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/v0.66.tar.gz"
  sha256 "9f87ff002405501b12798a715b691496775a4f9727188eeba167143816992a0f"
  license "MIT"
  revision 1
  head "https://github.com/CorsixTH/CorsixTH.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "651735456e7376c1de75b2499680f1ee88a9a3231c36db84d8acce27717a62df"
    sha256 arm64_monterey: "a8dbc402542a59704db0075dc3a1542977efd7cda3eeb0e24db11ee9c1b1ed6a"
    sha256 arm64_big_sur:  "ff512592cf6ca0bfcb6cf11f48f63d275771d00ca2803707da7cac5331314051"
    sha256 ventura:        "1306f8e8678784f4b8949b7771e0e5063782faf822102a06fbd68e785895322c"
    sha256 monterey:       "66fc4a0640c757456c4efcc2113c0afecabbece807de950285ea577092221966"
    sha256 big_sur:        "64645106c33f43df0b0d308c48d90d129b5d0d1df39bdd20f94b3a464b02ef6a"
    sha256 catalina:       "b43968804acbf0f5baac47c2a8bb9a638f1f6a6478d83d5e846bb1c6cfb66837"
    sha256 x86_64_linux:   "c36909397a1ff699f08baa76a3bae1379b78eed27557fd3cd5279d01d48a8cae"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "mesa"
  end

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

    datadir = OS.mac? ? prefix/"CorsixTH.app/Contents/Resources/" : pkgshare
    args = std_cmake_args + %W[
      -DLUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua")}
      -DLUA_PROGRAM_PATH=#{lua.opt_bin}/lua
      -DCORSIX_TH_DATADIR=#{datadir}
    ]
    # On Linux, install binary to libexec/bin so we can put an env script with LUA_PATH in bin.
    args << "-DCMAKE_INSTALL_BINDIR=#{libexec}/bin" unless OS.mac?

    system "cmake", ".", *args
    system "make"
    if OS.mac?
      resources = %w[
        CorsixTH/CorsixTH.lua
        CorsixTH/Lua
        CorsixTH/Levels
        CorsixTH/Campaigns
        CorsixTH/Graphics
        CorsixTH/Bitmap
      ]
      cp_r resources, "CorsixTH/CorsixTH.app/Contents/Resources/"
      prefix.install "CorsixTH/CorsixTH.app"
    else
      system "make", "install"
    end

    lua_env = { LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"] }
    bin_path = OS.mac? ? prefix/"CorsixTH.app/Contents/MacOS/CorsixTH" : libexec/"bin/corsix-th"
    (bin/"CorsixTH").write_env_script(bin_path, lua_env)
  end

  test do
    if OS.mac?
      lua = Formula["lua"]

      app = prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
      assert_includes MachO::Tools.dylibs(app), "#{lua.opt_lib}/liblua.dylib"
    end

    PTY.spawn(bin/"CorsixTH") do |r, _w, pid|
      sleep 30
      Process.kill "KILL", pid

      output = ""
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end

      assert_match "Welcome to CorsixTH", output
    end
  end
end
