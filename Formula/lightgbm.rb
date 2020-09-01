class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM/archive/v3.0.0.tar.gz"
  sha256 "940563ece81d94eb843c2d1dc702da5af7c2a67fb1ccf31d64b39e00262d35b5"
  license "MIT"

  bottle do
    cellar :any
    sha256 "b8b078e8458186a058a47ba94d302dfb3688cae329112594bbbb125712c5c79a" => :catalina
    sha256 "eefdb9c1c9749755431ac7fafc09bc9d3d31d73d6d9077f4e0a9d6d89ae4d032" => :mojave
    sha256 "afaa412201c008a88980e9ecd9967d4ccfacdaa967229f084457e3780cba3b78" => :high_sierra
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
