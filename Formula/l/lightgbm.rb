class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/lightgbm-org/LightGBM"
  url "https://github.com/lightgbm-org/LightGBM.git",
      tag:      "v4.6.0",
      revision: "d02a01ac6f51d36c9e62388243bcb75c3b1b1774"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5f1ea9bad948745d1a776b3f6e22de75e68d2bd35b07cc8be5bf2708282edd75"
    sha256 cellar: :any,                 arm64_sequoia: "941389cbcebba0522f6581f80743288967e6a88f804ae66293d8247278ba9c6c"
    sha256 cellar: :any,                 arm64_sonoma:  "f5cb2cdb2cf8c0c0dae47767eabf872ae9d7689ec4871ec5137351bfc76c9c81"
    sha256 cellar: :any,                 sonoma:        "28f87da7161377f42756c169baf7433cf748c06758dbfba1e5a19f151bc425ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7560fb6a214227ee5280f19181941f792551ff06811616e21de8963ff80c5b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef8b3d3e381a03b1f27596284a4c55f4b4939ad23f950a8559945201c7d4d469"
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
