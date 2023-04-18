class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v3.3.5",
      revision: "ca035b2ee0c2be85832435917b1e0c8301d2e0e0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7d94dc1085f6834d2d38ae1d6155333d56c0862bb45a9bb51cb6fedee8d26d2d"
    sha256 cellar: :any,                 arm64_monterey: "ae03ad63f5ae164e1cd92eda00b6af59edd4a3cbb6d1e32dafd3b4a8e7c38ace"
    sha256 cellar: :any,                 arm64_big_sur:  "0b9a840386e5ae60ec7b0a5b727ef4bf4bc889e7fcd4d2842727d1cc2288ce4c"
    sha256 cellar: :any,                 ventura:        "515f6e0358450ecf2b8d1980c9f95879f79a6ed4bb17f87fdc6d4603a86234fd"
    sha256 cellar: :any,                 monterey:       "fcaab8c7cc809659bcbb7cd706fd7ce736fed68e50da11e43c4a11e53e11cd19"
    sha256 cellar: :any,                 big_sur:        "d48012904a9b82656108d8f40101864bfe4df0fe7f05ec3695287fe4b812450f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "780b9b26acd666842f6f031ca321a67ba9979751f19daa2c39725950e87b1f97"
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
