class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v3.3.3",
      revision: "a0a617dfff2e2e1637b72b7a2adbe5453e7f97e0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "608ec71093c5032d541d162523ca61da5dc75cae2f75ffba727e391e7b880379"
    sha256 cellar: :any,                 arm64_monterey: "918af46783680319f01d1173c31810cfe767202baa4d42b69173131bef01de71"
    sha256 cellar: :any,                 arm64_big_sur:  "3d45c91704e3462b2b41ca91e934a791507e5c3994917770db95e2b74fdc0595"
    sha256 cellar: :any,                 ventura:        "a4b0b3b1775dec3bd6232c4b4d69752e380d39e31158acc4fc7f70c6a4619b28"
    sha256 cellar: :any,                 monterey:       "e13f4270b50d04416bb96002b6fc67556e3dde967a113bf4123599e79439cd48"
    sha256 cellar: :any,                 big_sur:        "7b97ee4f76abaec2a2fc4f1f97a8a0725f2ed3ab1e9a91cd7025ca5be7153914"
    sha256 cellar: :any,                 catalina:       "1f48fc264c40bc505beb3f29976ea606980c0d04a48ac1e12446af46d3e467e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d5e12ba59005339f668ea5bafdab5f17f61ebaf8d8d1dee7601eef64ddf6f57"
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
