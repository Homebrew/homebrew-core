class Libtorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v1.9.1",
      revision: "dfbd030854359207cb3040b864614affeace11ce"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "259a9ade3880026cddffbadac967405d7a8900cce1d43739456f4acdd826a864"
    sha256 cellar: :any,                 catalina:     "49c7b2cbd6f18a984be41fe3412a7928e54533acb171abdc89311cff0eb9eab5"
    sha256 cellar: :any,                 mojave:       "65e1c0c4b62cbc28eb547f4139f8f42e007c9ad940475cbae74791b6dcb747a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "563944e7996b82ccc32336fb6e46ee95ad8394a0163af50fdb359c1783ed697e"
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

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
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
      inreplace "caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx

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
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}/torch/csrc/api/include",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system "./test"
  end
end
