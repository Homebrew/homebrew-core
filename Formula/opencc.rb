class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.1.1.tar.gz"
  sha256 "2d4987dc84275f252d47bc6d8c81b452f6a6e82caa26f284c854a8153ccf5933"

  bottle do
    sha256 "4406670454c6ddd241093780a0b4bd239b0d62d2b1f4dacd0f525d3de12264eb" => :catalina
    sha256 "7886d354cf8780196a82dc4aadb0971e6a0aa1f991cf42d4003218da24c884d1" => :mojave
    sha256 "f2955488d0649b306b8e05cad4a0f99093f1da60b0edbaf8a9e6f0e0b133889f" => :high_sierra
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
