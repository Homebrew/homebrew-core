class Libtorch < Formula
  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v1.12.1",
      revision: "664058fa83f1d8eede5d66418abff6e20bd76ca8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "371aaf05a3111a0e97e0797935459cc26beb7728032fd94ab5eda3c92fa7b613"
    sha256 cellar: :any,                 arm64_big_sur:  "5f876f013b675409fef89b0bab5a276b2f61e336096bd00958018afe9d6a2efc"
    sha256 cellar: :any,                 monterey:       "9d9eb127a4ae1ff7f1b38de5838ee4828da565725240f4344b22a9c5ca3aa2c0"
    sha256 cellar: :any,                 big_sur:        "e3455a23a41b185fa104b428c858d59012b9177786a3da9f9cadae81de01a5a3"
    sha256 cellar: :any,                 catalina:       "8692e8d9089749c1a6af496f53e58d0030579a05b4dff38c0e8dfae8ffbd68a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5431c5ba7e283a5f88b81194d1e6579e9b92b5c6610a4011ca1bbad7f196a63"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "eigen"
  depends_on "libyaml"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "python-typing-extensions"
  depends_on "pyyaml"

  on_macos do
    depends_on "libomp"
  end

  # Update fbgemm to a version that works with macOS on Intel.
  # Remove with next release.
  resource "fbgemm" do
    url "https://github.com/pytorch/FBGEMM.git",
    revision: "0d98c261561524cce92e37fe307ea6596664309a"
  end

  def install
    rm_r "third_party/fbgemm"

    resource("fbgemm").stage(buildpath/"third_party/fbgemm")

    args = %w[
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=OFF
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

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args, *args

    # Avoid references to Homebrew shims
    inreplace "build/caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
