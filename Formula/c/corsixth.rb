class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "08eec141bdd8adf265f341a8452601f844a3eaab0378535b2655198fd373a7f8"
  license "MIT"
  revision 1
  head "https://github.com/CorsixTH/CorsixTH.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "d753e18ec56907c2b0033343d131b80390f15d1ba7ad9db9e5ccb43bb98b43af"
    sha256 arm64_sequoia: "3cb067dfba410ffb3801e0e70d5d4a79841742cdf81b1d295aa378b2702f0d20"
    sha256 arm64_sonoma:  "915084f0279e8c300639051bc5ac2451afdc29676b48bd3ecb4c61d18710c9b6"
    sha256 arm64_ventura: "753909b4988900d132e387f99e064d2979063e1543e984e5825880f561db419f"
    sha256 sonoma:        "c5f817b34df2a948e14936c85ccabf8b13bbc58208031a142f68d9904e8bf67c"
    sha256 ventura:       "529c7ad432164591a315b326e0aaa2c0f50ff96ab75265072cb29a5f588c844b"
    sha256 arm64_linux:   "eab424f31ed2b847de8ad0be1637b02471ea557609652143bb361c849f6603fb"
    sha256 x86_64_linux:  "649e38315d446085d93dfcf3014a204d878ceb68ff4d999cf7a42d4071af90ab"
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
    url "https://github.com/keplerproject/luafilesystem/archive/refs/tags/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
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
