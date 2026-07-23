class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://lightgbm.readthedocs.io/en/latest/"
  url "https://github.com/lightgbm-org/LightGBM.git",
      tag:      "v4.7.0",
      revision: "8f7036f03627054d5a54a6f965b13f4b9ff2cb63"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "81a2c2e9d6c58ebe62d3ee5ae2bf5afe07967be9ad67320dafbdb799dfe49766"
    sha256 cellar: :any, arm64_sequoia: "6be02dfd098823dc8835851fc93f0669fd885204bfb30f583c708741a60bc9b7"
    sha256 cellar: :any, arm64_sonoma:  "feb0f42f3dfe1bc949f4c800b4209ad338a454b33bc0fce95b4390c9472e1483"
    sha256 cellar: :any, sonoma:        "186ddc835fff711bb086418dbd3433bcaf5ba4ef7808d415b5fbb74113930162"
    sha256 cellar: :any, arm64_linux:   "3679e77c8bf109a883ac1771bb63df40910e348810b64608ecf049295c0b4954"
    sha256 cellar: :any, x86_64_linux:  "4b67660b126962ada824f45832f7c2ce9306b99ded52f4c29637e26b4b20d728"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/regression"), testpath
    cd "regression" do
      system bin/"lightgbm", "config=train.conf"
    end
  end
end
