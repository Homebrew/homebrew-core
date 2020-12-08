class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM/archive/v3.1.1.tar.gz"
  sha256 "a1e64bff404f448681ee33fb131a6218c4388574b83df0d25f45e63268a03b44"
  license "MIT"

  bottle do
    cellar :any
    sha256 "d164f0cf1ead997543806e7d6ecdd44aa36fb1d5fb1b30a4fb45e50e97f58d41" => :big_sur
    sha256 "de69b09945578e7912c03820580f59b41a979bc1babe3949d7bfcad574446698" => :catalina
    sha256 "35b7bd53ac73e1c2d0c5d736f85f3e3dc7d264e354b2a10f63c3ed6733cea3b8" => :mojave
    sha256 "7adcfa409b33f5e7b528ef8f5a11b148619947f36f0dbc43c8b3ca754f58180e" => :high_sierra
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
