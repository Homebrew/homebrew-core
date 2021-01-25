class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.1.1.tar.gz"
  sha256 "2d4987dc84275f252d47bc6d8c81b452f6a6e82caa26f284c854a8153ccf5933"
  license "Apache-2.0"

  bottle do
    sha256 "11b266b2cbae3e9ec7912dbb0b4784aae0d2868da37082414e6206e104fc9926" => :big_sur
    sha256 "dddf951ae0363e1e92c34d3d0087233d8d07053682557fd1bbed457aa98c677f" => :catalina
    sha256 "0503b49e5fcec9652ea10a3ab14d182babf48aae43644c68b243b94c2a781182" => :mojave
    sha256 "d48b56dec1d0f6f0fe0eb2690f8ac152e8dc13971c40649fe5e6ba810efdec17" => :high_sierra
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
