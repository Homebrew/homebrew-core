class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.1.2.tar.gz"
  sha256 "8c0f44a210c4ee0cc79972d47829b2f3e1e90a26c4db0949da3ad99a8d1fe375"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "ac777a972c663aefbc43930b5776eedd1541d93ab2a56e3ad4f02094da662ca3"
    sha256 big_sur:       "9d31934fcd9abeebb3c0c6a36b7e7aa7c7a658b579da5b1533e02bcd530a6f6f"
    sha256 catalina:      "f740a308d7ebe1d4091e9e7ee412606353efd8a1d6ef653937613279fb08d63d"
    sha256 mojave:        "505d227dc8e6acaddaf1c7bbb0b1a367c8eccbadb3d66a44e9d310054f13478b"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..", "-DBUILD_DOCUMENTATION:BOOL=OFF", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make"
      system "make", "install"
    end
  end

  test do
    input = "中国鼠标软件打印机"
    output = shell_output("echo #{input} | #{bin}/opencc")
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end
