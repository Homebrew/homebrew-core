class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM/archive/v3.0.0.tar.gz"
  sha256 "940563ece81d94eb843c2d1dc702da5af7c2a67fb1ccf31d64b39e00262d35b5"
  license "MIT"

  bottle do
    cellar :any
    sha256 "24a02453d33224cbe3f0d5f2f623d1356eb4b26c6bb6367e0da4c644ffaedd60" => :catalina
    sha256 "681eaac747cc86830db2d7162715803a794b95678af3d9072dafa80483ee6699" => :mojave
    sha256 "8cbaa97be86257f42bcaecfc1b8ee805558351e11438976606f9f58a897ed23d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, "-DAPPLE_OUTPUT_DYLIB=ON", ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/regression"), testpath
    cd "regression" do
      system "#{bin}/lightgbm", "config=train.conf"
    end
  end
end
