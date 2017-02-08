class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/2.4.1.tar.gz"
  sha256 "2368d6e7a38ce1e82feea3848d10916f52caf6103579ac5fbc2bd6dcfdf89c6e"
  head "https://github.com/instead-hub/instead.git"

  bottle do
    sha256 "7e363add5c92102b75aa71690bfcf68279aa573a06fb6e63457e840ad4111502" => :el_capitan
    sha256 "9db3e6ff43659ea9b63ad59dbf27ee02d159d137d3e6aeabb2bffbab93b35f3b" => :yosemite
    sha256 "09210457cf3c12e9afa5fc9e5a14cfe09a0c31ea072f9bee041125d68de79535" => :mavericks
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
