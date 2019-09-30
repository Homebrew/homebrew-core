class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM/archive/v2.3.0.tar.gz"
  sha256 "e076034ef41229714d59f28c3bd2366830dd9dfb9deff62f9ebc6a26f9e1e975"

  bottle do
    cellar :any
    sha256 "bc6300c70a89b96692e156fec5b69ead6f5797796002f5fb977a017d8ccb7186" => :catalina
    sha256 "c49a9182068e8b8fa353d395fcf63dd3b4928c57205ce590da7a0d03d09c2bf9" => :mojave
    sha256 "b4760edce9d2024bfde2be08c38d5f38e24d57b62a20ee9e858c6e6c288ebe09" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      libomp = Formula["libomp"]
      args = std_cmake_args
      args << "-DOpenMP_C_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
      args << "-DAPPLE_OUTPUT_DYLIB=ON"

      system "cmake", *args, ".."
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
