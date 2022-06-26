class Libtorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v1.11.0",
      revision: "bc2c6edaf163b1a1330e37a6e34caf8c553e4755"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "ade0e2426a912e8d258bb3fe0526e3411ef0476fcfed0fc49adb86f0c0117cd4"
    sha256 cellar: :any,                 arm64_big_sur:  "382de43ea289eb525774caeeabc6d55aba6c6dcebda187d947fb5704f09322b0"
    sha256 cellar: :any,                 monterey:       "8a0e504fa8c7203f836a75497dbbd01900dafbf87ed96c431362f08d39ba5e16"
    sha256 cellar: :any,                 big_sur:        "e00080ee66a776d07a397aca9e5cbe78e5b4b3b7e4ba3f4c593a36c3b8fb21cd"
    sha256 cellar: :any,                 catalina:       "52f809178bf99c740c9f45905397617df6856b59ce21aaa5ae175442ef46f547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70acc2535e0856a43896c394f2014ed58d65c5f7cda15a692bc33d7d2bda4bfb"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "eigen"
  depends_on "libyaml"
  depends_on "protobuf"
  depends_on "pybind11"

  on_macos do
    depends_on "libomp"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/b1/5a/8b5fbb891ef3f81fc923bf3cb4a578c0abf9471eb50ce0f51c74212182ab/typing_extensions-4.1.1.tar.gz"
    sha256 "1a9462dcc3347a79b1f1c0271fbe79e844580bb598bafa1ed208b94da3cdcd42"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", Formula["python@3.10"].opt_bin/"python3")
    venv.pip_install resources

    args = %W[
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=OFF
      -DPYTHON_EXECUTABLE=#{buildpath}/venv/bin/python
      -DUSE_CUDA=OFF
      -DUSE_METAL=OFF
      -DUSE_MKLDNN=OFF
      -DUSE_NNPACK=OFF
      -DUSE_OPENMP=ON
      -DUSE_SYSTEM_EIGEN_INSTALL=ON
      -DUSE_SYSTEM_PYBIND11=ON
    ]
    # Remove when https://github.com/pytorch/pytorch/issues/67974 is addressed
    args << "-DUSE_SYSTEM_BIND11=ON"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args

      # Avoid references to Homebrew shims
      inreplace "caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx

      system "cmake", "--build", ".", "--target", "install"
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
