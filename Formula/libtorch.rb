class Libtorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      :tag      => "v1.4.0",
      :revision => "7f73f1d591afba823daa4a99a939217fb54d7688"

  bottle do
    cellar :any
    sha256 "b6d4961d7c1baaff41dd09ec6a37c1a4bc991886b2c24155572eaa693f687a3f" => :catalina
    sha256 "d75117d358cdc75fdd03caff3fc77b3a0ef91bf3d457d4eccf6c77d1b9332eee" => :mojave
    sha256 "4f4e8bff70d04eeef62e99411cc9bafedfb14082e50f500911c809bd20433b5d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build
  depends_on "eigen"
  depends_on "libomp"
  depends_on "protobuf"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/3d/d9/ea9816aea31beeadccd03f1f8b625ecf8f645bd66744484d162d84803ce5/PyYAML-5.3.tar.gz"
    sha256 "e9f45bd5b92c7974e59bcd2dcc8631a6b6cc380a904725fce7bc08872e691615"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/67/b0/b2ea2bd67bfb80ea5d12a5baa1d12bda002cab3b6c9b48f7708cd40c34bf/typing-3.7.4.1.tar.gz"
    sha256 "91dfe6f3f706ee8cc32d38edbbf304e9b7583fb37108fef38229617f8b3eba23"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    args = %W[
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=OFF
      -DPYTHON_EXECUTABLE=#{libexec}/bin/python
      -DUSE_CUDA=OFF
      -DUSE_METAL=OFF
      -DUSE_MKLDNN=OFF
      -DUSE_NNPACK=OFF
      -DUSE_SYSTEM_EIGEN_INSTALL=ON
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args
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
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-ltorch", "-lc10",
      "-I#{include}/torch/csrc/api/include", "test.cpp", "-o", "test"
    system "./test"
  end
end
