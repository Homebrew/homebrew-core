class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM/archive/v3.1.1.tar.gz"
  sha256 "a1e64bff404f448681ee33fb131a6218c4388574b83df0d25f45e63268a03b44"
  license "MIT"

  bottle do
    cellar :any
    sha256 "e439b3e99f5df4196b48c937cd6b38be16fd566c04e3b52ba78610eaaa8c6185" => :big_sur
    sha256 "b5003bf5c04772c9fad6c34134bee20ec9bd25cb1e9b7c438e704b0f88aa325b" => :arm64_big_sur
    sha256 "ff1a50ff028ff22997b0a2807f50bec7d4ef8a297ee0a0965d938166983943a0" => :catalina
    sha256 "055dbb284840813e365d14b020d9c01c96491ce6586fe6f1b9e90236f8d9f605" => :mojave
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
