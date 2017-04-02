class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://dl.bintray.com/byvoid/opencc/opencc-1.0.4.tar.gz"
  sha256 "34e728ba9819477e8f8e12726867965e6aa55e7f3390225b2c031f9138b404cb"

  bottle do
    sha256 "3c228bd803e8914ee9ca3ed00eb67fa9dfcacd8f1a99c5532962d5c4a87acb57" => :sierra
    sha256 "9ddf2bdf0563a14a3e1bff8e5a067c605ac59b9f1611c69640035cdb7df6ddfd" => :el_capitan
    sha256 "add47f6baf00f83d3ca00d7da59e35f18506f7858e1e6aede4f04660411f2e06" => :yosemite
    sha256 "88192e5f330e185f4f18fbd3b6f8e7e5cac7a0f22d88059471ef3fad25a85c77" => :mavericks
  end

  depends_on "cmake" => :build

  needs :cxx11

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
