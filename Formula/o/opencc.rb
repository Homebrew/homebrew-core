class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.1.3.1.tar.gz"
  sha256 "1cc663704ff15728d6ea41ced8cd9dcc086f7bd9a80e8531b2f8054d2f3b8733"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/BYVoid/OpenCC.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "591ba4f3b3d2a5c75f346450759a75645cf9d4ead293aee029711f4516710eb3"
    sha256 arm64_sequoia: "7374ebb5b9fe32296913faf7e730a30e3bda9dc7c62e4e236bb9fecb321c2895"
    sha256 arm64_sonoma:  "33ec0628c320472651c3dd80f5a32e8cdaf97b2ba7d0eb6cfd4163bc2aab8907"
    sha256 sonoma:        "2e16308d74b6393e374667c7302647bdb8ca97e93731414142fc337272f39a56"
    sha256 arm64_linux:   "c0ed290e76d711edb47f76cdaf5815f57b133e6ac7d56cb659dc7306fa241fc3"
    sha256 x86_64_linux:  "c133c27d6f2216b72f4e5cad57507908b3f8ecf5dd9ea7f8ecc4f71ee6057ed6"
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
