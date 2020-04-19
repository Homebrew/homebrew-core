class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.3.2.tar.gz"
  sha256 "bdb827f36e693dc7b443e69d4678d24f1ccc20dc093c22f58b8d78192da15f2e"

  bottle do
    sha256 "e020cbe4c016591b3c017d0df239b0704ca7b4076c2f61d47ffbb44b67f151b0" => :catalina
    sha256 "64eda82eb27e394732b69b0811515f9ac5cb4549bfe6014b21ed0a80507e0f83" => :mojave
    sha256 "176bc087885f093320ee60548e0f5162f07531a6e2d4e4f360dbd31d6f670091" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF",
                            "-DLUA_INCLUDE_DIR=#{Formula["lua"].opt_include}/lua",
                            "-DLUA_LIBRARY=#{Formula["lua"].opt_lib}/liblua.dylib",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /INSTEAD #{version} /, shell_output("#{bin}/instead -h 2>&1")
  end
end
