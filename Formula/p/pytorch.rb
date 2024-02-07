class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch/releases/download/v2.2.0/pytorch-v2.2.0.tar.gz"
  sha256 "e12d18c3dbb12d7ae2f61f5ab9a21023e3dd179d67ed87279ef96600b9ac08c5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c035e0ee70deb9bb0a3a82d6b1cd5bea3d62a4bd73dd21f1b45e07ba1e040918"
    sha256 cellar: :any,                 arm64_ventura:  "f525b5aa9969686496af14a0d56b7ff1d1949130f906c1513511c9dded62fd73"
    sha256 cellar: :any,                 arm64_monterey: "36c5f8699befe9c52a32c515ee9045076314e3e961190ea5bc862cfbc1233e94"
    sha256 cellar: :any,                 sonoma:         "736106009a30d7a1a4af9f5452b618ee114a83eab479c65b5ea2b71d86ed8d9c"
    sha256 cellar: :any,                 ventura:        "ed8ab2a547c53a08ea135996d74541beb06375afc085db495d53b786e901b574"
    sha256 cellar: :any,                 monterey:       "2124c51cea12d1a1df62b4ad4174e12735da6a3710e56a6c6837a1d19dac69f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e64648434f56c73d84fe75e8356d705673278485e74bf34354f4960cffa231c"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on xcode: :build
  depends_on "eigen"
  depends_on "libuv"
  depends_on macos: :monterey # MPS backend only supports 12.3 and above
  depends_on "numpy"
  depends_on "openblas"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "python-filelock"
  depends_on "python-jinja"
  depends_on "python-networkx"
  depends_on "python-sympy"
  depends_on "python-typing-extensions"
  depends_on "pyyaml"
  depends_on "sleef"

  on_macos do
    depends_on "libomp"
  end

  resource "opt-einsum" do
    url "https://files.pythonhosted.org/packages/7d/bf/9257e53a0e7715bc1127e15063e831f076723c6cd60985333a1c18878fb8/opt_einsum-3.3.0.tar.gz"
    sha256 "59f6475f77bbc37dcf7cd748519c0ec60722e91e63ca114e68821c0c54a46549"
  end

  def install
    python3 = "python3.12"

    ENV["ATEN_NO_TEST"] = "ON"
    ENV["BLAS"] = "OpenBLAS"
    ENV["BUILD_CUSTOM_PROTOBUF"] = "OFF"
    ENV["BUILD_PYTHON"] = "ON"
    ENV["BUILD_TEST"] = "OFF"
    ENV["PYTHON_EXECUTABLE"] = which(python3)
    ENV["USE_CUDA"] = "OFF"
    ENV["USE_DISTRIBUTED"] = "ON"
    ENV["USE_METAL"] = "OFF"
    ENV["USE_MKLDNN"] = "OFF"
    ENV["USE_NNPACK"] = "OFF"
    ENV["USE_OPENMP"] = "ON"
    ENV["USE_SYSTEM_EIGEN_INSTALL"] = "ON"
    ENV["USE_SYSTEM_PYBIND11"] = "ON"
    ENV["USE_SYSTEM_SLEEF"] = "ON"
    ENV["USE_MPS"] = "ON" if OS.mac?

    # Avoid references to Homebrew shims
    inreplace "caffe2/core/macros.h.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "opt-einsum" }
    resource("opt-einsum").stage do
      # Workaround versioneer script broken on 3.12
      # https://github.com/dgasmith/opt_einsum/issues/221
      inreplace "setup.py", "cmdclass=versioneer.get_cmdclass(),", ""
      inreplace "setup.py", "version=versioneer.get_version(),", "version='#{version}',"
      venv.pip_install_and_link Pathname.pwd
    end
    venv.pip_install_and_link(buildpath, build_isolation: false)

    # Expose C++ API
    torch = libexec/Language::Python.site_packages(python3)/"torch"
    include.install_symlink (torch/"include").children
    lib.install_symlink (torch/"lib").children
    (share/"cmake").install_symlink (torch/"share/cmake").children
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}/torch/csrc/api/include",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system "./test"

    # test that the `torch` Python module is available
    system libexec/"bin/python", "-c", <<~EOS
      import torch
      t = torch.rand(5, 3)
      assert isinstance(t, torch.Tensor), "not a tensor"
      assert torch.distributed.is_available(), "torch.distributed is unavailable"
    EOS

    if OS.mac?
      # test that we have the MPS backend
      system libexec/"bin/python", "-c", <<~EOS
        import torch
        assert torch.backends.mps.is_built(), "MPS backend is not built"
      EOS
    end
  end
end
