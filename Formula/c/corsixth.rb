class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/refs/tags/v0.70.3.tar.gz"
  sha256 "83bb446923f161f42cc0ff6de7fa47f4fb23c455973c40e0b5708d91193b1ed8"
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
    manifest_sha256 "5d5c3c70e5a6ac459686c9057684ec111584db871a951ffc1ef95e0277dd803e"
    sha256 arm64_golden_gate: "ffa8183fcbf6dde5cdfcfd5159450310493004f2f9ea53f9c40fe6906cba830b"
    sha256 arm64_tahoe:       "9e7e67bf20a753e7fe06a0adc875a1be446fd7c25e80eb12e3358d93db5c4a2d"
    sha256 arm64_sequoia:     "17e8b42e4ffb995f5bfaed76e63239df6621d9432d14e452d5bccd4288d38047"
    sha256 arm64_linux:       "98b4c5ca2df8dd35527c20330c021e29eb7748f3bbf34c8cb0ad5197cc97a681"
    sha256 x86_64_linux:      "8384768b6e8977d6ec8701f72ef59e6afb621be69fb227a0c373b6bc8bf3dd85"
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

    datadir = if OS.mac?
      prefix/"CorsixTH.app/Contents/Resources/"
    else
      pkgshare
    end
    args = std_cmake_args + %W[
      -DLUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DLUA_LIBRARY=#{lua.opt_lib}/#{shared_library("liblua")}
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
    bin_path = if OS.mac?
      prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
    else
      libexec/"bin/corsix-th"
    end
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
