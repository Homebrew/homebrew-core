class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.1.1.9.tar.gz"
  sha256 "ad4bcd8d87219a240a236d4a55c9decd2132a9436697d2882ead85c8939b0a99"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia:  "a27e13aa2de9e5c4775f1618842f8a94ba0399462295427f1c01ecb0bad59e45"
    sha256 arm64_sonoma:   "40bbcc0ea4cceadf579f5bcefded29585f45a18e42bba6ee2a0f0f8b9093f30c"
    sha256 arm64_ventura:  "517a8dfe20b621aad9d4f8fd9118794b53318f07007ee1ec1fb7081065921184"
    sha256 arm64_monterey: "addb0ef3712437c10de21dfe670291144d1fa36d6c2661016cfbdba0d6a0e9f1"
    sha256 sonoma:         "125d0aa542c79a1c64ff50d6bb65f37b8a1df08842d2aadea4de148ad4fd7834"
    sha256 ventura:        "a6da927e23614ddef3ff4199a162a5ddb81ad3d0414e3943adc1622d5a0eebed"
    sha256 monterey:       "86fab72d30ba153353798d51f6f1e0ef3136b9edd23d69497fb3b8303cebfb72"
    sha256 x86_64_linux:   "127925772f41d4145e6f4ee5f74f08cea701fdce389b743174b960dc1e80629d"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = "中国鼠标软件打印机"
    output = pipe_output(bin/"opencc", input)
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end
