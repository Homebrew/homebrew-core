class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.3.2.tar.gz"
  sha256 "bdb827f36e693dc7b443e69d4678d24f1ccc20dc093c22f58b8d78192da15f2e"
  license "MIT"
  revision 2

  bottle do
    sha256 "71af1e349e6da503d572dbe2b0cd969a33020fa9101bbe9692c56c85e02e676c" => :big_sur
    sha256 "a2f65af64781e9b45d363bdf589ab614286cf5342d585699527f63af6cf5d008" => :catalina
    sha256 "d3fb0b0cb48c58ee904d783df541cd71eac200a58ba9a4e9e7a8bffe7c9800b1" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "luajit"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF",
                            "-DWITH_LUAJIT=ON",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /INSTEAD #{version} /, shell_output("#{bin}/instead -h 2>&1")
  end
end
