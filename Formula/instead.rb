class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.3.3.tar.gz"
  sha256 "1425c559ab91c8ec3e02ad74f6989a4408ee7141d69361d17aeff174d194fe57"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "eb951c76454e1555ab7aa01910a03ddfcec6c73ebede17f642646b8dc317d7c2"
    sha256 big_sur:       "40e256b5936267f917823861c18d88c18416623791ed4be21c2a7c0314e64b7e"
    sha256 catalina:      "9b7fda751518f7f2035b040e3e28d7f4fc603fe3741dea1040be82952856e4af"
    sha256 mojave:        "b0127d13891f56fd1eb9cc44c0abd5503451ad12adc1ada98a15dbd53f067f28"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
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
