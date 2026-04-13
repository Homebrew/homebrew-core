class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.1.2.0.tar.gz"
  sha256 "f4f86eb25e239450d075081e08594801aa063c298d21d9f6c6aa85cd55241962"
  license "Apache-2.0"
  head "https://github.com/BYVoid/OpenCC.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "f4f32d831b4c4efcce4985889f1b97c2d72cf0fa70072a1510c364abbf4d41a8"
    sha256 arm64_sequoia: "5578577376fe775dc84f81c713f24f437acfee1a44a26ac2ad437e556bf14448"
    sha256 arm64_sonoma:  "5cc429e1b9d04539158ad25800c46a89a9aa86bff75abcf745f51818b67551c9"
    sha256 sonoma:        "c9dfebbc8c0a1ade2338055f3304f1099c7ac6c6ab8eaf99b26bef6af61a299d"
    sha256 arm64_linux:   "a3c0b445c400a2d6f520b0747058b770cfc798a8095f8331b501ad325dfb2b81"
    sha256 x86_64_linux:  "d8e0a358a41f411513b78d9d4a4ec5fc978d4c832474f4824e10d58a9fab187a"
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
