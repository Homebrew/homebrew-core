class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.1.3.0.tar.gz"
  sha256 "548e890c9a882df4f121bad7e52751581e94e9a043767549f7e233524a46be75"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/BYVoid/OpenCC.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "c648cd113d6f72bada9ee991b3799ae0ee0fb1963dee9c5c77ca734b5c9a6f49"
    sha256 arm64_sequoia: "7462d09fb86500c8d4dc2066a7ce6008310c6a0a514229d32977e71521d0685d"
    sha256 arm64_sonoma:  "92f3862704376f5d90aed44d5df3ae4e3f0121202298a653a8a556033422e1f2"
    sha256 sonoma:        "7a2e4b1719d92421f879d0018a8c6d82895bfaa123b4b35d782a042eed34f668"
    sha256 arm64_linux:   "c09e04400b3dc70a4fb257ea8b30791d297d12302699a31d508221ffdd69a57b"
    sha256 x86_64_linux:  "eaa73cb45f116ea6159d24d84b36ca864ca2f4b41b2641eb2886bd460cfc4de9"
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
