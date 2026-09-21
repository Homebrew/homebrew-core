class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/refs/tags/v0.70.1.tar.gz"
  sha256 "b3a37b09f168f30600d305314f5a823d3af10bf407074e9a837e0e85acfe9ba3"
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
    sha256 arm64_golden_gate: "7ebd30c6a0b51cd345b25df418b9ef7c6c57cf9331ecd66bfe03021d471d50e9"
    sha256 arm64_tahoe:       "7557dd28cec742e975a8d12022ea6b21a4083bf538dee279968e728badc80c0f"
    sha256 arm64_sequoia:     "e1c89b5f871313c7b3f646de6c5a6cd75cc2e7719af0a8c74a885a4705bfc421"
    sha256 arm64_sonoma:      "d5f9cf90b301b0a1f87eb15a49d9dbc7303f70e9d9c988ed4be21ecdc618e4e0"
    sha256 arm64_linux:       "1693d2b4220b7dfa9d62ec6dae6657aeee3d860c29adc267a7d1335af1068fc1"
    sha256 x86_64_linux:      "bfd93732ee7667445750e9a0579a7c934abcc6ad7495b62223bd598c40fb4f39"
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
