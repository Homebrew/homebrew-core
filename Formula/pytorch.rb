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
    sha256 cellar: :any,                 arm64_ventura:  "e1d8881ea30b057f582e5e908bc97f4922aca0680054b05bc9d3ad7c6da191a3"
    sha256 cellar: :any,                 arm64_monterey: "17dd6a096eee8aecdfd693be17ee30f207f2ada880e52ae3a8bc8a39d7c8cf23"
    sha256 cellar: :any,                 arm64_big_sur:  "c9a913b6c2a60970338d9ed82f9be168b992f05bbde109f0f65cddaaf0cef602"
    sha256 cellar: :any,                 monterey:       "41479b4c2d8e9ee045fde9f6f0845c6f154da08e0195acde96462cda084cc863"
    sha256 cellar: :any,                 big_sur:        "74be80be51c2842d3cd81125f4ea71b2fdff940446c4a513835e66629df88479"
    sha256 cellar: :any,                 catalina:       "a1654f4f335fa0f76b99355b9ef2118eb4225c41d189c282beb75d0fc0302164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8621ecee06694da1a68357a4fb40417905b8c3de0c486dfc8f0ce2dcac32804"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => [:build, :test]
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
    python_exe = Formula["python@3.10"].opt_libexec/"bin/python"
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
    python = Formula["python@3.10"]
    system python.opt_libexec/"bin/python", "-c", <<~EOS
      import torch
      torch.rand(5, 3)
    EOS
  end
end
