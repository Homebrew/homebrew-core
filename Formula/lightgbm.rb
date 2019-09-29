class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM/archive/v2.3.0.tar.gz"
  sha256 "e076034ef41229714d59f28c3bd2366830dd9dfb9deff62f9ebc6a26f9e1e975"

  bottle do
    cellar :any
    sha256 "6b0e9080fcf9489c9163e793a03b0f9c26e9c4a6edea02170462ccff675a814b" => :mojave
    sha256 "a7627eb122264e31f54b32d1fe29559ef77cd0a67e6c532ebda098cf6a477abc" => :high_sierra
    sha256 "d8c8e257d9115cbfd61dd45f58faa72d98556367a9ae78f1562a729f35be3cee" => :sierra
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
