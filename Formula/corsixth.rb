class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/v0.65.tar.gz"
  sha256 "f951c9fcf7429accf035aeaeab681f7f9172af66b8475e9bacb32f5375515227"
  license "MIT"
  head "https://github.com/CorsixTH/CorsixTH.git"

  bottle do
    sha256 arm64_big_sur: "fb20eddb21a89396791d6ab3dfdf13c0bde91c44ba0a6f068b59194b361c4690"
    sha256 big_sur:       "9852913d485e6fce557001d16f78dac562b205c44810d93b133b539c02ed0436"
    sha256 catalina:      "bad3d139e3cac3c277a9bea632819fe27b90abfd7d5305813f839d78f5854ca6"
    sha256 mojave:        "a68aaf41d6feda1bbed25fa4fbb7ff73dc4b5049e23c13fb9377b22cb23c17a4"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  def install
    lua = Formula["lua"]

    args = std_cmake_args + %W[
      -DLUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DLUA_LIBRARY=#{lua.opt_lib}/liblua.dylib
      -DCORSIX_TH_DATADIR=#{prefix}/CorsixTH.app/Contents/Resources/
      -DWITH_LUAROCKS=ON
    ]
    system "cmake", ".", *args

    system "make"
    system "make", "install"
    bin.write_exec_script prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
  end

  test do
    lua = Formula["lua"]

    app = prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
    assert_includes MachO::Tools.dylibs(app),
                    "#{lua.opt_lib}/liblua.#{lua.version.major_minor}.dylib"
  end
end
