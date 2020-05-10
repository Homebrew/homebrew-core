class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.1.0.tar.gz"
  sha256 "5f5e33ba91e2a36fe84a7ef61d0172410a97813ff2bd0618cd70b37ae3ec560c"

  bottle do
    sha256 "b7a7f1bb5baaeaf825983c965f5b09425e83a431d68cc672167db15abdb1f6ab" => :catalina
    sha256 "458e5845c3138cef9959f4a9b88da3d8728ef304df6217ad6766f5fef31874f1" => :mojave
    sha256 "da5513e9bd1c4acb8db7aba36c284bfef7a738aba08612f48342e96cb19710fe" => :high_sierra
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
