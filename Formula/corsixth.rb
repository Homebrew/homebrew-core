class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/v0.65.1.tar.gz"
  sha256 "b8a1503371fa0c0f3d07d3b39a3de2769b8ed25923d0d931b7075bc88e3f508f"
  license "MIT"
  revision 1
  head "https://github.com/CorsixTH/CorsixTH.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "654811f4e5a3540862b868be587f6a44c25453a946952d36d9c0b67a06bafff2"
    sha256 arm64_big_sur:  "85711a57a88a670524cb047baef9f8fe98ce5e2023fb0b513d08a8473ca46ed4"
    sha256 monterey:       "45fcd5591710383a1b437f6d74266b6a9d1f587f3b820b8a0499199bf581e4c2"
    sha256 big_sur:        "400cdf58edc5407ba28bdc2437fef922a1ab4748c6c74dc047a6a6273291f583"
    sha256 catalina:       "d4b4c1abbd7c4329792a2a96304d95b8289d5f5f4be841872e5a9079e2349cf0"
    sha256 x86_64_linux:   "23e347e4c34e7b5ffdb7738adf242fd742ce36de7f4eb6b19510f07bac61f688"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on xcode: :build
  depends_on "ffmpeg@4"
  depends_on "freetype"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "gcc"
    depends_on "mesa"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
