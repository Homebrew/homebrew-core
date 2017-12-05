class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.1.2.tar.gz"
  sha256 "622c04a58fd780d8efdf0706c03596ab68672b31e97865dad6a1fc1540619754"
  revision 1
  head "https://github.com/instead-hub/instead.git"

  bottle do
    sha256 "c32e167811c88818b649817d4818b8d11b90b1645c2fe5617edef47e5ae0e0f1" => :high_sierra
    sha256 "3bb245499347467119715fc9c8def74ef8f6f23775845ae5a37b266bf25f8951" => :sierra
    sha256 "2ca1a0a758d0e7a404fb62082e8058e915dbd6922c3c0db62937899f3e99fdd8" => :el_capitan
    sha256 "da97fc64cb2c10bc4aa7271d99cefedb3b6fdad308fcfaa3b16628ba1c9a9283" => :yosemite
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
