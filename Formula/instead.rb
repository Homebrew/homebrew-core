class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.1.2.tar.gz"
  sha256 "622c04a58fd780d8efdf0706c03596ab68672b31e97865dad6a1fc1540619754"
  revision 1
  head "https://github.com/instead-hub/instead.git"

  bottle do
    sha256 "a0a3ea00027270c2e2c187875cf0d927ea3774e9d15cecc22ad79a71f5a4055d" => :high_sierra
    sha256 "553fe8895598076f95471f287dc1de07833015eaf1cb0458a68a520c842270b2" => :sierra
    sha256 "6dfd28908d6b1106557b956999bc80a98918ccd5f0b97089748c087b2c4bd7be" => :el_capitan
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
