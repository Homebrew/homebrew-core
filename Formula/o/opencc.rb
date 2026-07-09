class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://opencc.byvoid.com/"
  url "https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.1.4.0.tar.gz"
  sha256 "088483cd6051d06c2850eefba33b3c30a6e34485027bbc8949eb90548d6f714e"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/BYVoid/OpenCC.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "4c1cb881ea5fbf513674594d802a32b0f758ffcdfb5f4e42c36c381d23d1d5cb"
    sha256 arm64_sequoia: "60a27c717288f29c31ac9b4bce81c88c1e231e2455537ef349729a9560314abc"
    sha256 arm64_sonoma:  "9ff5e3e3b826ed3312e07e4e4d0a2e4f20c995e7464009bb0ea79412397cc438"
    sha256 sonoma:        "723f56bf03deea8a2925e18a5a6f5747343c63f0a35d1344b7c8057304f4210d"
    sha256 arm64_linux:   "40b7215e4c9c3c098fe559b5234146915f788942d8c2c8f117d86d9183e9718d"
    sha256 x86_64_linux:  "0fe94a9ebce3ab09db35763ad4e6f49d8d43ce4c3143db9516afe13c0789d79d"
  end

  depends_on "cmake" => :build
  depends_on "marisa"
  uses_from_macos "python" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
      -DUSE_SYSTEM_MARISA=ON
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
