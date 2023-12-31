class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v4.2.0",
      revision: "0a9a6bbf6d96cb01c3fdc7ace6b13da828857c82"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "719bfcf008e3565603a47e7d6af96e6b3e7d984e68ced7bdafd6e87eee05144b"
    sha256 cellar: :any,                 arm64_ventura:  "d97f5439fdc5664237e7c531fe7aeb0c8c6e0d614e214051b97a0d53c419e004"
    sha256 cellar: :any,                 arm64_monterey: "cd1ed66be1efdb2599f96dbe1fa5fc0317f7e8ed05c397b7eb0d9683a1c363b5"
    sha256 cellar: :any,                 sonoma:         "39fdcde3c989ab43cfa4e639f7f81e3c58d025a070736e19c3a46f1fd76aec7e"
    sha256 cellar: :any,                 ventura:        "e5ae080a13efa292896ae9248f958908be33cf095ad2f7c255258d1d1d462383"
    sha256 cellar: :any,                 monterey:       "54f72af175b30a96bc11e86303ce89d312f21ccb841f312ca6b019589384cbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38d19596bcca94dd784cb3dac3f3beb3768ea4e989fba070898191405c4f1189"
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
