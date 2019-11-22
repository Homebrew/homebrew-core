class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.0.5.tar.gz"
  sha256 "1ce1649ba280cfc88bb76e740be5f54b29a9c034400c97a3ae211c37d7030705"

  bottle do
    sha256 "5a217a645ad950e10b28abd054fd205ee92cc9475e965874c9e4ea1d45a08087" => :catalina
    sha256 "13a6e88594f5f83ae12c7b1d76e54a8dca45f5babf9132dbbe10d8280517a69f" => :mojave
    sha256 "698426f43bf80050cf64ab752d64ae86644e4c491086b641794a8a4491a7c616" => :high_sierra
    sha256 "b53f5db30a9865924dde847f6e6bbb7c86f61d08376e89f2566a21494e834a5c" => :sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", ".", "-DBUILD_DOCUMENTATION:BOOL=OFF", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    input = "中国鼠标软件打印机"
    output = shell_output("echo #{input} | #{bin}/opencc")
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end
