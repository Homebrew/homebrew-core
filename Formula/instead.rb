class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.0.0.tar.gz"
  sha256 "c31c38523b666a43d8f639c433b3e9b7470b38b300e94b718181493f575921e5"
  head "https://github.com/instead-hub/instead.git"

  bottle do
    sha256 "e9247bfb6fa8dc1d36beceaa25b1fdd8aadf030180a29290c47c3a08d5e4955c" => :sierra
    sha256 "3c3fec9d009b66f94a0b352e82c71032d3863bb4945d58613488a2f0cdc0cda4" => :el_capitan
    sha256 "a2f6f219e7669db12bbb994a92f79bbeedd0652d05d53d4a29b73dc574ef3403" => :yosemite
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
