class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.1.2.tar.gz"
  sha256 "622c04a58fd780d8efdf0706c03596ab68672b31e97865dad6a1fc1540619754"
  head "https://github.com/instead-hub/instead.git"

  bottle do
    sha256 "ebdffab6ded1dbf290557c97b527850c0c1954b5b9fe056d61dd3691e7c2b07d" => :sierra
    sha256 "119ff61c433c09e5eb345f5325115f214b9760649c2fdfdae9d685b78d57574b" => :el_capitan
    sha256 "db8716b2b847a7d1eb133ac961416f83cc92b0931f245a3c8dc0326b54f9bf78" => :yosemite
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
