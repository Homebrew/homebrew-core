class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.0.5.tar.gz"
  sha256 "1ce1649ba280cfc88bb76e740be5f54b29a9c034400c97a3ae211c37d7030705"

  bottle do
    sha256 "4c5e5a613f0b12b3fd1dd9ca7d4dce6c67d0b1b9edd2d7b6cf52446e35d1eb27" => :mojave
    sha256 "9a4d1024105557dbb8caad9548473bbbc384b4178e880a996d1b843eeaac5df1" => :high_sierra
    sha256 "3c228bd803e8914ee9ca3ed00eb67fa9dfcacd8f1a99c5532962d5c4a87acb57" => :sierra
    sha256 "9ddf2bdf0563a14a3e1bff8e5a067c605ac59b9f1611c69640035cdb7df6ddfd" => :el_capitan
    sha256 "add47f6baf00f83d3ca00d7da59e35f18506f7858e1e6aede4f04660411f2e06" => :yosemite
    sha256 "88192e5f330e185f4f18fbd3b6f8e7e5cac7a0f22d88059471ef3fad25a85c77" => :mavericks
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
