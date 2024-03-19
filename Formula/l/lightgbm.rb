class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v4.3.0",
      revision: "252828fd86627d7405021c3377534d6a8239dd69"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ee7f8e225f2aa0f7e280cfbd73c697ba109ddc721454bf55a1dd56041030f25f"
    sha256 cellar: :any,                 arm64_ventura:  "376c8ddb9b365bad17a7196dd05b71c351508d0900100d431116cdd199849551"
    sha256 cellar: :any,                 arm64_monterey: "c8885481711d04d77e866cd295cd9831aeb6c0be0d806b092df2d31ed709d2ed"
    sha256 cellar: :any,                 sonoma:         "c7e7caea57e3ae1bdbc81ec7d5d5bc4d0bf53eba848080049f4cb1e83b291a78"
    sha256 cellar: :any,                 ventura:        "e8ea10a38e133ffe056ed506137ab65f8ef495062c69320d197d045098a9d263"
    sha256 cellar: :any,                 monterey:       "8a119d40d2afe865d8962cf7da97afd03332257bb9476d16423d1f637e466ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af0ee70c512eee78cbf32402719d4f33d1209cfb0d2ff70aaa086fde3ad51f10"
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
