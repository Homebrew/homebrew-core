class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.3.2.tar.gz"
  sha256 "bdb827f36e693dc7b443e69d4678d24f1ccc20dc093c22f58b8d78192da15f2e"
  license "MIT"
  revision 3

  bottle do
    sha256 "bd0463eca5582cfb5e6a5db1befaa55a0fa7be8580296fc32b690873fb134e1e" => :big_sur
    sha256 "cd2c8eaae8f35bcd76dabe29ffbba977913c31b23df407dfcc1959b9946dacc2" => :catalina
    sha256 "8052e44079c28c8d997e005be8d43844803e8be1d340016608cf28833fc6edb2" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "luajit-openresty"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    luajit = Formula["luajit-openresty"]
    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF",
                            "-DWITH_LUAJIT=ON",
                            "-DLUA_INCLUDE_DIR=#{luajit.opt_include}/luajit-2.1",
                            "-DLUA_LIBRARY=#{luajit.opt_lib}/libluajit.dylib",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /INSTEAD #{version} /, shell_output("#{bin}/instead -h 2>&1")
  end
end
