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
    sha256 "5e338a006640ff951d2d087317daeae35936b159465ab180b0132eba69b2f412" => :high_sierra
    sha256 "ce70fb520401ead2b042a2322887a4e04d84ff3ee94ff0895df63603930570b8" => :sierra
    sha256 "b3c2a857a44b0072b0499767f9bfe5c7ef562038351481ab4c647f48e52bbc4f" => :el_capitan
    sha256 "879015e727a6decec4d24f65d810890caa766107339e81f1e6c6b96a70e1b944" => :yosemite
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
