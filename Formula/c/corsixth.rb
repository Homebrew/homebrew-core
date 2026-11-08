class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/refs/tags/v0.70.2.tar.gz"
  sha256 "7664645a97d9d56a287bdd55035fb325050840fa743c2854f7ff3198ecee1f26"
  license "MIT"
  head "https://github.com/CorsixTH/CorsixTH.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "b6bdb24cf1424967534a02033ae9920ce926d5bd77ec7c0c06538df8f3a108dd"
    sha256 arm64_tahoe:       "5495cd9b75151e8ebc16da5a8aa4a9a0a26d1f938547442b9d8e299b3a092649"
    sha256 arm64_sequoia:     "7b367b5903115cd339a13da03d462a4dff0501d2a0a72cde851d8e08417fe38c"
    sha256 arm64_linux:       "ea129f3b54a33fbd7f51fec0f04cfaf686d3ba405eebbffa0431ba0e41b15072"
    sha256 x86_64_linux:      "8201a5b4864cdaf23e12f65272d6b08e1f1b3d9279587971d37977c43d16b21d"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "lpeg" => :no_linkage
  depends_on "lua"
  depends_on "rtmidi"
  depends_on "sdl2-compat"
  depends_on "sdl2_mixer"

  uses_from_macos "curl"

  on_linux do
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  resource "luafilesystem" do
    url "https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_9_0.tar.gz"
    sha256 "1142c1876e999b3e28d1c236bf21ffd9b023018e336ac25120fb5373aade1450"
  end

  # Make sure I point to the right version!
  def lua
    Formula["lua"]
  end

  def install
    ENV["TARGET_BUILD_DIR"] = "."
    ENV["FULL_PRODUCT_NAME"] = "CorsixTH.app"

    luapath = libexec/"vendor"
    # Append `;;` to keep default search path.
    ENV["LUA_PATH"] = luapath/"share/lua"/lua.version.major_minor/"?.lua;;"
    ENV["LUA_CPATH"] = luapath/"lib/lua"/lua.version.major_minor/"?.so;;"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}", "--lua-dir=#{lua.opt_prefix}"
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

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    if OS.mac?
      resources = %w[
        CorsixTH/CorsixTH.lua
        CorsixTH/Lua
        CorsixTH/Levels
        CorsixTH/Campaigns
        CorsixTH/Graphics
        CorsixTH/Bitmap
      ]
      app = buildpath/"build/CorsixTH/CorsixTH.app"
      cp_r resources, app/"Contents/Resources"
      prefix.install app
    else
      system "cmake", "--install", "build"
    end

    lua_env = { LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"] }
    bin_path = OS.mac? ? prefix/"CorsixTH.app/Contents/MacOS/CorsixTH" : libexec/"bin/corsix-th"
    (bin/"CorsixTH").write_env_script(bin_path, lua_env)
  end

  test do
    if OS.mac?
      require "utils/linkage"
      app = prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
      assert Utils.binary_linked_to_library?(app, lua.opt_lib/"liblua.dylib"), "No linkage with lua!"
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
