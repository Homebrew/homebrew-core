class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v4.1.0",
      revision: "501ce1cb63e39c67ceb93a063662f3d9867e044c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a09d820579b06354d4ec35ec1182a1156e9a27d3b0790a9e655b06f4bfbbb51"
    sha256 cellar: :any,                 arm64_ventura:  "0010391af6b282c9669b7cd3bca7864733c00016009eb957130967fea279b2bc"
    sha256 cellar: :any,                 arm64_monterey: "7a80dbccdcca058e93f29d2c72c68f0935ee2cce7aec1682390990565ad37259"
    sha256 cellar: :any,                 arm64_big_sur:  "e3e5bf298df53c0bfdd06dc2f060a902af2f4a580405d85866adb5cc6b790965"
    sha256 cellar: :any,                 sonoma:         "c3b3c0657347d6f0f6903110b8e933b429326c13fb4dc63372cb016ca766387e"
    sha256 cellar: :any,                 ventura:        "a64217c8391e55d64eb0ffc224a8743c647656040eeb06e8f00e31f28f91ae0d"
    sha256 cellar: :any,                 monterey:       "40b1201fb46110abfe4507ef4979a3b014e675c67f0d737bae32d8986868cbfc"
    sha256 cellar: :any,                 big_sur:        "226ffcf3c5f0c21f8ba1fe865fb207ec07e47fde82b1df25184a99cb27b447c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b75a9a8690a5406be254cfea07b4f3887d366e45a345f18aeb9ae7dc8553e1"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DAPPLE_OUTPUT_DYLIB=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/regression"), testpath
    cd "regression" do
      system "#{bin}/lightgbm", "config=train.conf"
    end
  end
end
