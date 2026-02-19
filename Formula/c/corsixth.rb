class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/refs/tags/v0.69.2.tar.gz"
  sha256 "cbad15f9a16edd4c068ce14fb17f39cdb811dab0135fca80fafffa9a45732aec"
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
    sha256 arm64_tahoe:   "e4db49792837ef97ede9e390becba49c9ca4b5b74cdb65a3db2830a982245edc"
    sha256 arm64_sequoia: "85f3c97033e315c7002e410857f2a896018fe5b93a446f95b83f0cdefd910f62"
    sha256 arm64_sonoma:  "76d79a2109ccc63b17bd1a6f73af0f69d8d1df514f40b5bab953a8c19a20fde6"
    sha256 sonoma:        "17ad046129a03c40a7cade3dd01425574eb4861068b463b55e9370e7b6e09ecd"
    sha256 arm64_linux:   "133802d597b3c9ca344b8e70f79012380cb02d93eb76f8e97bd7ba742847da82"
    sha256 x86_64_linux:  "b5b7c68918ad8a91cda1a2c1a1b56d6de38a9e238e2a2b8299f64824f3f4ecf0"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "lpeg"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "curl"

  on_linux do
    depends_on "mesa"
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/refs/tags/v1_9_0.tar.gz"
    sha256 "1142c1876e999b3e28d1c236bf21ffd9b023018e336ac25120fb5373aade1450"
  end

  def install
    # Make sure I point to the right version!
    lua = Formula["lua"]

    ENV["TARGET_BUILD_DIR"] = "."
    ENV["FULL_PRODUCT_NAME"] = "CorsixTH.app"

    luapath = libexec/"vendor"
    # Append `;;` to keep default search path.
    ENV["LUA_PATH"] = luapath/"share/lua"/lua.version.major_minor/"?.lua;;"
    ENV["LUA_CPATH"] = luapath/"lib/lua"/lua.version.major_minor/"?.so;;"

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
      require "utils/linkage"
      lua = Formula["lua"]
      app = prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
      assert Utils.binary_linked_to_library?(app, lua.opt_lib/"liblua.dylib"), "No linkage with lua!"
    end

    PTY.spawn(bin/"CorsixTH") do |r, _w, pid|
      sleep 30
      sleep 30 if OS.mac? && Hardware::CPU.intel?
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
