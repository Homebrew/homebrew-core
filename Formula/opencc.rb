class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.1.5.tar.gz"
  sha256 "7de5b1fd9e3950c1eb05e306aaa7cbf1f92f813748514eb2b447700795a64e02"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "e0d807f71948b0ca7e224fc0fcb10236fe6158603ef3f2c5aa055624dda231d5"
    sha256 arm64_monterey: "b3b6c98505d778bffac40244ff3550082c67043700c11f8b4c2dc470bd708adb"
    sha256 arm64_big_sur:  "79dbf338581ae748fcbd116e8c6ec45c57a74fc950205c11e05aa586b6601bc6"
    sha256 ventura:        "04ec43a5224dd4389194ef92589ce198f4e3cc8c85332578fa3d53da1a9dd5fc"
    sha256 monterey:       "abb5f38218d666e864435b8fdcc8dc83e5a9d74f6d5b72d13dddc518e2d068b2"
    sha256 big_sur:        "04e1e578598037552c24853cf84d2ed66da5d23f517612ea8e793e5ba44cc0c7"
    sha256 catalina:       "4dcee8df044e226db8af14ecee5ae84785b799a648c421e6d2f00768df9b30be"
    sha256 x86_64_linux:   "3e911567c4bed3312fcb55d777f00383b91e4d847633afe9d4b3f0af9c59d802"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    ENV.cxx11
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    input = "中国鼠标软件打印机"
    output = pipe_output("#{bin}/opencc", input)
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end
