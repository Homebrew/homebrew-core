class Pytorch < Formula
  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v1.13.0",
      revision: "7c98e70d44abc7a1aead68b6ea6c8adc8c554db5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d57efe34670fa32cd8e01d805ad3464c6a19e2d8dd36e55cc63aac2f3a780c8e"
    sha256 cellar: :any,                 arm64_monterey: "a12968f1df7070107bf6d271858a5a7415fe42c0b570ac1fc969cd2683cd6780"
    sha256 cellar: :any,                 arm64_big_sur:  "8637fcdc0ed320f328f94625bcbb87769d2a6802734ff88d4ffd79b5b8a70da5"
    sha256 cellar: :any,                 ventura:        "425ed374e5d21a1b299a9c4d7c391a4ef731868a7873124794019dbdf92527fb"
    sha256 cellar: :any,                 monterey:       "d20c43be3d583b7fdae31c58e64549314066b8b5248dda130ce1ec83060e9412"
    sha256 cellar: :any,                 big_sur:        "349d106bc09f3c83185278d191ddb13cccaa21349d797f408398e2940ea9b8d1"
    sha256 cellar: :any,                 catalina:       "a61996b933e1dda4d5ae5519f89d5284d8e0054c95685fc2325a97b58c0dd5cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f95437daa1de22c5e368ec54c568d99948d1ecac4ca0497de61726bfdead8d87"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "eigen"
  depends_on "libuv"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "python-typing-extensions"
  depends_on "pyyaml"

  on_macos do
    depends_on "libomp"
  end

  def install
    openssl_root = Formula["openssl@1.1"].opt_prefix
    python_exe = Formula["python@3.11"].opt_libexec/"bin/python"
    args = %W[
      -GNinja
      -DBLAS=OpenBLAS
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=ON
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_C_COMPILER=#{ENV.cc}
      -DOPENSSL_ROOT_DIR=#{openssl_root}
      -DPYTHON_EXECUTABLE=#{python_exe}
      -DUSE_CUDA=OFF
      -DUSE_DISTRIBUTED=ON
      -DUSE_METAL=OFF
      -DUSE_MKLDNN=OFF
      -DUSE_NNPACK=OFF
      -DUSE_OPENMP=ON
      -DUSE_SYSTEM_EIGEN_INSTALL=ON
      -DUSE_SYSTEM_PYBIND11=ON
    ]
    # Remove when https://github.com/pytorch/pytorch/issues/67974 is addressed
    args << "-DUSE_SYSTEM_BIND11=ON"

    ENV["LDFLAGS"] = "-L#{buildpath}/build/lib"

    # Update references to shared libraries
    inreplace "torch/__init__.py" do |s|
      s.sub!(/here = os.path.abspath\(__file__\)/, "here = \"#{lib}\"")
      s.sub!(/get_file_path\('torch', 'bin', 'torch_shm_manager'\)/, "\"#{bin}/torch_shm_manager\"")
    end

    inreplace "torch/utils/cpp_extension.py", "_TORCH_PATH = os.path.dirname(os.path.dirname(_HERE))",
                                              "_TORCH_PATH = \"#{opt_prefix}\""

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args, *args

    # Avoid references to Homebrew shims
    inreplace "build/caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx

    system python_exe, *Language::Python.setup_install_args(prefix, python_exe)
  end

  test do
    # test that C++ libraries are available
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

    # test that `torch` Python module is available
    python = Formula["python@3.11"]
    system python.opt_libexec/"bin/python", "-c", <<~EOS
      import torch
      torch.rand(5, 3)
    EOS
  end
end
