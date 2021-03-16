class Libtorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v1.8.0",
      revision: "37c1f4a7fef115d719104e871d0cf39434aa9d56"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, big_sur:  "08759cfe3f5c0ab60f1d74332703d67c9ca54bafe6be60afab7a210518af7920"
    sha256 cellar: :any, catalina: "4f5ccf4bc4b19c2eca0ef12fd06d820b181cb9b7b3187e6259a7ecc352372c27"
    sha256 cellar: :any, mojave:   "8975867c5c88ed33c6db76dda75b65bb650c31a60eadcbb12c7fe1b7eab74e70"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on "eigen"
  depends_on "libomp"
  depends_on "libyaml"
  depends_on "protobuf"
  depends_on "pybind11"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/05/d9/6eebe19d46bd05360c9a9aae822e67a80f9242aabbfc58b641b957546607/typing-3.7.4.3.tar.gz"
    sha256 "1187fb9c82fd670d10aa07bbb6cfcfe4bdda42d6fab8d5134f04e8c4d0b71cc9"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resources

    args = %W[
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=OFF
      -DPYTHON_EXECUTABLE=#{buildpath}/venv/bin/python
      -Dpybind11_PREFER_third_party=OFF
      -DUSE_CUDA=OFF
      -DUSE_METAL=OFF
      -DUSE_MKLDNN=OFF
      -DUSE_NNPACK=OFF
      -DUSE_OPENMP=OFF
      -DUSE_SYSTEM_EIGEN_INSTALL=ON
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args

      # Avoid references to Homebrew shims
      inreplace "caffe2/core/macros.h",
                "{\"CXX_COMPILER\", \"#{HOMEBREW_SHIMS_PATH}/mac/super/clang++\"},",
                "{\"CXX_COMPILER\", \"/usr/bin/clang++\"},"

      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <torch/torch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10",
      "-I#{include}/torch/csrc/api/include", "test.cpp", "-o", "test"
    system "./test"
  end
end
