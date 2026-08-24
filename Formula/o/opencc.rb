class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://opencc.byvoid.com/"
  url "https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.1.4.2.tar.gz"
  sha256 "8e5f5cf7fe195bd9b9be851adc9738c1ef7dc5c24441dd5878a56db4087a9a70"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/BYVoid/OpenCC.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "bbfaf3efb79e2c3f5c28164da7fac4392e37f92d2bd6c29f90b2f56e524f4e46"
    sha256 arm64_sequoia: "2c624b20369b7b59f090e9843f63885f83dbcbaacca1a1ad14b83dcc5913eb2e"
    sha256 arm64_sonoma:  "25644bad6d717f0aa881606c7bc0b1d2b741980805c0fd498158f0afbcc573da"
    sha256 sonoma:        "e727557f893d4c502e902dc857cdb64645f39544b9ff970e82ee25923804c482"
    sha256 arm64_linux:   "f85c97dd2e6ac5119b88f00caf011d47fbf4f0b3474c5cc05138a3a4ff7ae19f"
    sha256 x86_64_linux:  "182985a5ea53917469b04f24814c97e0cf4623291ef892c17cd194a63b6a30b2"
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

    # The jieba segmentation plugin is only built by default on macOS
    return unless OS.mac?

    assert_path_exists lib/"opencc/plugins"/shared_library("libopencc-jieba")
    input = "城堡里的士兵"
    output = pipe_output("#{bin}/opencc -c s2twp_jieba.json", input)
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "城堡裡的士兵", output
  end
end
