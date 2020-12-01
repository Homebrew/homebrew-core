class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.3.2.tar.gz"
  sha256 "bdb827f36e693dc7b443e69d4678d24f1ccc20dc093c22f58b8d78192da15f2e"
  license "MIT"
  revision 1

  bottle do
    sha256 "4279441d1a315d876f9646a284ac3beefd109e7fa7c4ebce2fb8549bf0947d94" => :big_sur
    sha256 "e447bee8716c692d07e6d58b337639a64334dfa921326810c5ae0d64b14fe72e" => :catalina
    sha256 "128a389655c4361f48dd8ee81344682a3d4433485cf91569a71961bed0885e06" => :mojave
    sha256 "e9029b89e6133d0f233a679a684e64d0195b283aabb6c55640f8a95ed1297f50" => :high_sierra
  end

  depends_on "cmake" => :build

  # Possible patch for lua 5.4 support:
  # https://github.com/instead-hub/instead/commit/ea4f0e81c6859b0aadde582f47ffd7850f54a264
  # Alternatively, this dependency may be replaced with luajit, which is the
  # package's preferred version of lua:
  # https://github.com/instead-hub/instead/blob/master/INSTALL
  depends_on "lua@5.3"

  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    # Make sure I point to the correct lua version!
    lua = Formula["lua@5.3"]

    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF",
                            "-DLUA_INCLUDE_DIR=#{lua.opt_include}/lua",
                            "-DLUA_LIBRARY=#{lua.opt_lib}/liblua.dylib",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /INSTEAD #{version} /, shell_output("#{bin}/instead -h 2>&1")
  end
end
