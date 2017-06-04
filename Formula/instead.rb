class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.0.1.tar.gz"
  sha256 "62602c5cc54bcbce58ebf1bad3ee1e13ceee7c77abad71691fbdd138efd9426d"
  head "https://github.com/instead-hub/instead.git"

  bottle do
    sha256 "38832d4aa7daba7a51904ddc6ff4c4aa4a80e1500ac88efef5057db763447d5e" => :sierra
    sha256 "b0381e1ca4db11c8be2c108355e543049662cdf3cb11924d4b25e8ea79bfd109" => :el_capitan
    sha256 "214c2659f00fdab01785ee22bc335fe55fe04374026c2c85eb9a48705b60b517" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "lua"
  depends_on "sdl"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /INSTEAD #{version} /, shell_output("#{bin}/instead -h 2>&1")
  end
end
