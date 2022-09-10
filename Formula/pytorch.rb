class Pytorch < Formula
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
    depends_on arch: :arm64
    depends_on "libomp"
  end

  def install
    python_exe = Formula["python@3.10"].opt_libexec/"bin/python"
    openssl_root = Formula["openssl@1.1"].opt_prefix
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
      -DUSE_MAGMA=OFF
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

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args

      # Avoid references to Homebrew shims
      inreplace "caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx
    end

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
