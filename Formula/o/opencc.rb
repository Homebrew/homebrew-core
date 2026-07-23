class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://opencc.byvoid.com/"
  url "https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.1.4.1.tar.gz"
  sha256 "d4b94877c508a4774853f3b07330b3d25df00105c39dfba6ab9889d77946cc8a"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/BYVoid/OpenCC.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "51359818337caebfd198dae253a179cfc61036fc1510316fa7ed360f9a06db0d"
    sha256 arm64_sequoia: "1375d4ef4edfb228acdc5bd3000e577d8c48e3c8eb337a8121d4dcdc717e51a8"
    sha256 arm64_sonoma:  "b5e11bf53d642d6d88ae346137255975dc44a1d69f812983a6a31c7e44fbc030"
    sha256 sonoma:        "1f62546958e54c39900c4a60b2fd40922bc78b679a65e2bf2511208ed074807e"
    sha256 arm64_linux:   "b3328fd1a173c206a35b3e0fe4ec61319bbb5eee35956564d37624a01eee4e5d"
    sha256 x86_64_linux:  "59289d2400c4482a9883bb9d8202f9635b62a7fe1a818e95d14f4a8fb83d3511"
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
