class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.1.2.tar.gz"
  sha256 "8c0f44a210c4ee0cc79972d47829b2f3e1e90a26c4db0949da3ad99a8d1fe375"
  license "Apache-2.0"

  bottle do
    sha256 big_sur:  "27330e214cd6038426965f15216ae1edc3be0f4b47b32a73adca64aca9ab3759"
    sha256 catalina: "0a546b8fab339919ebc4b81bdee9863744db1c3eec4d72dc72d8396fbc9777f8"
    sha256 mojave:   "1ded47cd5ea2a8e6e494043e6c50b13ff2a05b04b3a6a201941a59d65806389f"
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
